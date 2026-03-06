{% if theme.mathjax.enable %}
  {% if not theme.mathjax.per_page or (page.total or page.mathjax) %}
    <script type="text/x-mathjax-config">
      MathJax.Hub.Config({
        tex2jax: {
          inlineMath: [ ['$','$'], ["\\(","\\)"]  ],
          processEscapes: true,
          skipTags: ['script', 'noscript', 'style', 'textarea', 'pre', 'code']
        },
        "HTML-CSS": {
          scale: 95,
          availableFonts: ["TeX"],
          preferredFont: "TeX",
          webFont: "TeX",
          imageFont: "TeX",
          showMathMenu: false
        },
        SVG: {
          scale: 95,
          font: "TeX"
        },
        displayAlign: "left",
        displayIndent: "0.5em"
      });
    </script>

    <script type="text/x-mathjax-config">
      MathJax.Hub.Queue(function() {
        var all = MathJax.Hub.getAllJax(), i;
        for (i=0; i < all.length; i += 1) {
          all[i].SourceElement().parentNode.className += ' has-jax';
        }
      });
    </script>
    <script type="text/javascript" src="{{ theme.mathjax.cdn }}"></script>
  {% endif %}
{% endif %}
