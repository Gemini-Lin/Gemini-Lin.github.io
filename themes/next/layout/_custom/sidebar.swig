{# recent_posts #}
{% if theme.recent_posts %}
  <div class="links-of-blogroll motion-element {{ "links-of-blogroll-" + theme.recent_posts_layout | default('block') }}">
    <div class="links-of-blogroll-title">
      <i class="fa  fa-fw fa-{{ theme.recent_posts_icon | default('globe') | lower }}"></i>
      {{ theme.recent_posts_title }}
    </div>
    <ul class="links-of-blogroll-list">
      {% set posts = site.posts.sort('-date') %}
      {% for post in posts.slice('0', '5') %}
	<li class="links-of-blogroll-item">
	  <a href="{{ url_for(post.path) }}" title="{{ post.title }}" target="_blank">{{ post.title }}</a>
	</li>
      {% endfor %}
    </ul>
  </div>
{% endif %}

