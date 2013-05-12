# This is the Octopress Gravatar plugin
#
# Place this file in your plugin directory and you have a _gravatar_ keyword to include gravatars image in your post.
#
# Usage: {% gravatar email@domain.com %}
#
# Paolo Perego, <thesp0nge@gmail.com>, v20120504.a
# repo@github: https://github.com/thesp0nge/octopress_gravatar_plugin
# twitter: @thesp0nge
# blog: http://armoredcode.com
#
require 'digest/md5'

module Jekyll
  class Gravatar < Liquid::Tag
    @email_address = nil
    @size = nil

    def initialize(tagname, options, tokens)
      
      options = options.split(" ")
      @email_address = options[0]
      @size = options[1]
    end

    def render(context)

      if context[@email_address]
        @email_address = context[@email_address]
      end
      hash = Digest::MD5.hexdigest(@email_address.downcase.gsub(/\s+/, ""))
      "<img class=\"gravatar\" src=\"http://www.gravatar.com/avatar/#{hash}?s=#{@size}\"/>"
    end

  end


end
Liquid::Template.register_tag('gravatar', Jekyll::Gravatar)
