---
title: SM2算法分析
date: 2020-06-29 15:35:49
tags:
- SM2
categories: 
- 课程总结
- 密码学
copyright: true
quicklink: true
---
# 基本参数确定
``` Python
# 选择素域，设置椭圆曲线参数
# m 为256bit长
default_ecc_table = {
'n': 'FFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFF7203DF6B21C6052B53BBF40939D54123',
'p': 'FFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFF',
# 基点G
'g': '32c4ae2c1f1981195f9904466a39c9948fe30bbff2660be1715a4589334c74c7'\
    'bc3736a2f4f6779c59bdcee36b692153d0a9877cc62a474002df32e52139f0a0',
'a': 'FFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFC',
'b': '28E9FA9E9D9F5E344D5A9E4BCF6509A7F39789F515AB8F92DDBCBD414D940E93',
}
```
<!--more-->
# 加密算法
``` Python
def encrypt(self, data):
    # 加密函数，data消息(bytes)
    msg = data.hex() # 消息转化为16进制字符串
    # 选择随机数k
    k = func.random_hex(self.para_len)
    # 进行点乘运算，计算椭圆曲线点C1=kG
    C1 = self._kg(int(k,16),self.ecc_table['g'])
    # 这里缺少了一步验证过程，S=hP_B
    # 计算椭圆曲线点kP_B
    xy = self._kg(int(k,16),self.public_key)
    # 从xy比特串中取出(x2,y2)
    x2 = xy[0:self.para_len]
    y2 = xy[self.para_len:2*self.para_len]
    ml = len(msg)
    # KDF密钥派生函数，用SM3算法产生伪随机数
    t = sm3.sm3_kdf(xy.encode('utf8'), ml/2)
    if int(t,16)==0:
        return None
    else:
        # 这边这个语法没搞懂，估计是取ml长的字符串，前面以0填充
        form = '%%0%dx' % ml
        # C2 = M⊕t
        C2 = form % (int(msg, 16) ^ int(t, 16))
        # C3 = Hash(x2||M||y2)
        C3 = sm3.sm3_hash([
            i for i in bytes.fromhex('%s%s%s'% (x2,msg,y2))
        ])
        return bytes.fromhex('%s%s%s' % (C1,C3,C2))
```
# 解密函数
``` Python
def decrypt(self, data):
    # 解密函数，data密文（bytes）
    data = data.hex() # 消息转化为16进制字符串
    len_2 = 2 * self.para_len
    len_3 = len_2 + 64
    # 从data中取出C1、C2、C3
    C1 = data[0:len_2]
    C3 = data[len_2:len_3]
    C2 = data[len_3:]
    # 利用私钥d_B,计算d_BC1=xy
    xy = self._kg(int(self.private_key,16),C1)
    # print('xy = %s' % xy)
    x2 = xy[0:self.para_len]
    y2 = xy[self.para_len:len_2]
    cl = len(C2)
    # 计算t=KDF(x2||y2,klen),klen=self.pare_len
    t = sm3.sm3_kdf(xy.encode('utf8'), cl/2)
    if int(t, 16) == 0:
        return None
    else:
        # 作用同上，格式化输出
        form = '%%0%dx' % cl
        # M = C2⊕t
        M = form % (int(C2,16) ^ int(t,16))
        # u = Hash(x2||M||y2)
        u = sm3.sm3_hash([
            i for i in bytes.fromhex('%s%s%s'% (x2,M,y2))
        ])
        return bytes.fromhex(M)
```
# 签名函数
``` Python
# 签名函数, data消息的hash，private_key私钥，K随机数，均为16进制字符串
def sign(self, data, K):  
    E = data.hex() # 消息转化为16进制字符串
    e = int(E, 16)
    # d 为16进制的私钥
    d = int(self.private_key, 16)
    k = int(K, 16)

    # 计算椭圆曲线点P1=kG=(x,y)
    P1 = self._kg(k, self.ecc_table['g'])

    x = int(P1[0:self.para_len], 16)
    # 计算R=(e+x)mod n
    R = ((e + x) % int(self.ecc_table['n'], base=16))
    if R == 0 or R + k == int(self.ecc_table['n'], base=16):# 纠错
        return None
    # d_1 = (d+1)^(n-2) mod n
    # 我觉得这边的写法主要是避免了求逆的计算
    d_1 = pow(d+1, int(self.ecc_table['n'], base=16) - 2, int(self.ecc_table['n'], base=16))
    # s = (d+1)^-1 * (k-Rd) mod n
    S = (d_1*(k + R) - R) % int(self.ecc_table['n'], base=16)
    if S == 0:
        return None
    else:
        return '%064x%064x' % (R,S)
```
# 验证函数
``` Python
def verify(self, Sign, data):
    # 验签函数，sign签名r||s，E消息hash，public_key公钥
    r = int(Sign[0:self.para_len], 16)
    s = int(Sign[self.para_len:2*self.para_len], 16)
    e = int(data.hex(), 16)
    # t = (r + s) mod n
    t = (r + s) % int(self.ecc_table['n'], base=16)
    if t == 0:
        return 0

    # P1 = sG
    P1 = self._kg(s, self.ecc_table['g'])
    # P2 = tP
    P2 = self._kg(t, self.public_key)
    # print(P1)
    # print(P2)
    # 有限域上的椭圆曲线加法公式
    if P1 == P2:
        P1 = '%s%s' % (P1, 1)
        P1 = self._double_point(P1)
    else:
        P1 = '%s%s' % (P1, 1)
        P1 = self._add_point(P1, P2)
        P1 = self._convert_jacb_to_nor(P1)

    x = int(P1[0:self.para_len], 16)
    # R = (e + x) mod n 验证 R=r是否成立
    return (r == ((e + x) % int(self.ecc_table['n'], base=16)))
```
[完整源码](https://github.com/duanhongyi/gmssl/blob/master/gmssl/sm2.py)