def link_example(name)
	syntax :ruby do
		content File.read("source/examples/#{name}.weave")
	end

	hyperlink "/examples/#{name}/", "See it in action"
end

def display_example(weaver_code)

	row do
		half do

			syntax :ruby do
				content weaver_code.chomp
			end
		end
		half do
			eval weaver_code
		end
	end

end

def create_menu

	menu do
		nav "Static Features", :"th-large", "/"
		nav "Dynamic Features", :"th-large", "/dynamic/"
		nav "Other Versions", :"th" do
			versions = ["v#{Weaver::VERSION}"]
			if File.exists? "available_versions"
				versions = File.read("available_versions").split("\n")
			end
			versions.each do |ver|

				velem = Weaver::Elements.new(self, @anchors)
				if "v#{Weaver::VERSION}" == ver
					velem.instance_eval do
						b ver
					end
				else
					velem.instance_eval do
						text ver
					end
				end
				nav velem.generate, :check, "http://davidsiaw.github.io/weaver-docs/#{ver}"
			end
		end
	end
	
end