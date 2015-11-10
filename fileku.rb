require 'sinatra'

get '/*?' do |dir|
  @path = '/' + dir.to_s.strip
  @path << '/' unless @path[-1, 1] == '/'
  @parent = File.dirname(@path)

  @nav = []
  @path[1..@path.size].split("/").each {|p| @nav << p}

  @dirs = []
  @files = []

  settings.the_root.chop! if settings.the_root[-1] == "/"

  if File.directory? "#{settings.the_root + @path}"
    Dir.foreach("#{settings.the_root + @path}") do |x|
      real_path = settings.the_root + @path + x
      if x != '.' && x != '..'
        if (x[0, 1] == '.' && settings.show_hidden) || (x[0, 1] != '.')
          if File.directory? real_path
            @dirs << @path + x
          else
            @files << @path + x
          end
        end
      end
    end
    haml :ls
  else
    file = "#{settings.the_root + @path}".chop
    send_file file, filename: File.basename(file), type: "application/octet-stream"
  end
end

__END__
@@ls
!!!
%html
  %head
    %title fileku.rb by ukazap
    %meta{charset: "utf-8"}
    %style
      *{font-family:sans-serif}a,a:visited{text-decoration:none;color:#{settings.color}}a:hover{text-decoration:underline}table{width:100%;background-color:#{settings.color}}table,td{border:1px solid #{settings.color}}tr{vertical-align:top}ul{list-style:square}
  %body
    %p
      %a{:href => "/"} [root]
      - path = ''
      - unless @nav.empty?
        - @nav.each do |folder|
          - path += "/" + folder
          \/
          %a{:href => "#{path}"}= folder
    %table
      %tr{style: "color: white"}
        %th= "Folders (#{@dirs.size})"
        %th= "Files (#{@files.size})"
      %tr{style: "background-color: white"}
        %td
          %ul
            %li
              %a{href: @parent} ..
            - @dirs.each do |d|
              %li
                %a{href: d}= File.basename d
        %td
          %ul
            - @files.each do |f|
              %li
                %a{href: f}= File.basename f
    %p
      %small
        %strong fileku.rb
        %em - simple, stupid web interface for sharing your files
        &copy;
        = Date.today.year
        %a{:href => "//github.com/ukazap"} Ukaza Perdana