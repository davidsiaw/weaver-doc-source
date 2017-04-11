require "fileutils"

`git log --pretty=format:"%H %ct" > doc-commits`
`git clone git@github.com:davidsiaw/weaver weaver-tmp`
`cd weaver-tmp; git log --tags --simplify-by-decoration --pretty="format:%ct %d" > ../weaver-tags`
`git clone git@github.com:davidsiaw/weaver-doc-source doc-tmp`

tag_list = File.read("weaver-tags").split("\n").map{|x| 
	m = /tag: (?<tag>v[0-9]+.[0-9]+.[0-9]+)/.match(x)
	{ 
		time: /^(?<epoch>[0-9]+)/.match(x)[:epoch], 
		tag: m ? m[:tag] : nil
	}
}.select{|x| x[:tag]}

commit_list = File.read("doc-commits").split("\n").map{|x|
	{
		commit: x.split(" ")[0],
		time: x.split(" ")[1]
	}
}

match = tag_list.map do |tag|
	commit = commit_list.bsearch{|commit| tag[:time] > commit[:time] }
	{
		tag: tag[:tag],
		commit: commit ? commit[:commit] : commit_list[-1][:commit]
	}

end

File.write("available_versions", tag_list.map{|x| x[:tag]}.join("\n"))

`bundle exec weaver build -r http://davidsiaw.github.io/weaver-docs/`

match.each do |x|

	puts "***************************************"
	puts "#{x[:tag]}"
	`cd weaver-tmp; git checkout #{x[:tag]}`
	`cd doc-tmp; git checkout Gemfile Gemfile.lock; rm -rf build; git checkout #{x[:commit]};`
	FileUtils.cp("available_versions", "doc-tmp")
	File.write("doc-tmp/Gemfile", <<-GEMFILE
source "https://rubygems.org"
gem "weaver", path: "#{`pwd`.chomp}/weaver-tmp"
	GEMFILE
	)
	`cd doc-tmp; bundle install; bundle exec weaver build -r http://davidsiaw.github.io/weaver-docs/#{x[:tag]}/`
	FileUtils.cp_r("doc-tmp/build", "build/#{x[:tag]}")
end
`rm -rf doc-tmp`
`rm -rf weaver-tmp`