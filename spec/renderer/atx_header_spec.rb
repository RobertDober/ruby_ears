require "ruby_ears/parser"
RSpec.describe RubyEars::Parser, type: :parser do
  # Not interested in rendering yet
  # context "AtxHeaders" do
  #   (1..6).each do |level|
  #     header = "#" * level
  #     text   = "Atx Header of level #{level}"
  #     it text do
  #       expect(parse_ok("#{header} #{text}")).to eq([quad("h#{level}", text)])
  #     end
  #   end
  # end
end
