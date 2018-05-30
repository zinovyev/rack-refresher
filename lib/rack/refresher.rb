module Rack
  class Refresher
    class Config
      attr_accessor :interval, :ajax

      def initialize
        @interval = 5000
        @ajax     = false
      end
    end

    def initialize(app)
      @app    = app
      @config = Config.new
      @mark   = rand(Time.now.to_i)
      yield(@config) if block_given?
    end

    def call(env)
      status, headers, body = @app.call(env)
      [status, headers, inject(body)]
    end

    private

    def inject(body)
      body = body.join("\n")
      [body.gsub!(/<\/body>/, render_template)]
    end

    def render_template
      template_name = @config.ajax ? :ajax_template : :template
      send(template_name, @config.interval)
    end

    def template(interval)
      <<-HTML
        </body>
        <script>
          var reloader_#{@mark} = setTimeout(() => { location.reload(); }, #{interval});
        </script>
      HTML
    end

    def ajax_template(interval)
      <<-HTML
        </body>
        <script>
          var reloadBody_#{@mark} = function() {
            var url = window.location.href;
            var xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = function() {
              if (this.readyState == 4 && this.status == 200) {
                let bodyTag = document.getElementsByTagName("body")[0];
                var parser = new DOMParser();
                var remoteDocument = parser.parseFromString(this.responseText, 'text/html');
                let remoteBodyTag = remoteDocument.getElementsByTagName("body")[0];
                bodyTag.innerHTML = remoteBodyTag.innerHTML;
              }
            };
            xhttp.open("GET", url, true);
            xhttp.send();
          }
          var reloader_#{@mark} = setInterval(() => { reloadBody_#{@mark}(); }, #{interval});
        </script>
      HTML
    end
  end
end
