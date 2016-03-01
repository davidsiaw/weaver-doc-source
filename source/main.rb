def link_example(name)
	syntax :ruby do
		content File.read("source/examples/#{name}.weave")
	end

	link "/examples/#{name}/", "See it in action"
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