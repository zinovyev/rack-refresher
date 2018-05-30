require_relative "../../spec_helper"

describe Rack::Refresher do
  let(:body) do
    <<-HTML
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <title></title>
      </head>
      <body>
        Hi
      </body>
      </html>
    HTML
  end
  let(:env) { {} }
  let(:app) { ->(_env) { [200, { "Content-Type" => "text/plain" }, [body]] } }
  subject { Rack::Refresher.new(app) }
  let(:response) { subject.call(env) }
  let(:response_body) { response[2].join }

  context "the application is just initialized" do
    it { is_expected.to respond_to(:call) }

    it "can be configured with a block" do
      expect(Rack::Refresher.new(app) {}).to respond_to(:call)
    end
  end

  context "the response is 200 OK" do
    context "all tags lowercased" do
      it "should inject a proper script to a reponse body" do
        expect(response_body).to match(/location\.reload\(\)/m)
      end
    end

    context "all tags uppercased" do
      let(:app) do
        ->(_env) { [200, { "Content-Type" => "text/plain" }, [body.upcase]] }
      end
      it "should inject a proper script to a reponse body" do
        expect(response_body).to match(/location\.reload\(\)/m)
      end
    end

    context "with modified delay value" do
      subject { Rack::Refresher.new(app) { |config| config.delay = 100_500 } }

      it "should inject a delay" do
        expect(response_body).to match(/100500/m)
      end
    end

    context "within an ajax reloader" do
      subject { Rack::Refresher.new(app) { |config| config.ajax = true } }

      it "should not inject a simple reload script to a reponse body" do
        expect(response_body).to_not match(/location\.reload\(\)/m)
      end

      it "should contain an ajax script for body reload" do
        expect(response_body).to match(/xhttp\.onreadystatechange/m)
      end

      context "with modified delay value" do
        subject do
          Rack::Refresher.new(app) do |config|
            config.ajax = true
            config.delay = 100_500
          end
        end

        it "should inject a delay" do
          expect(response_body).to match(/100500/m)
        end
      end
    end
  end
end
