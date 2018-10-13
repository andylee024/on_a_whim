# All files in the 'lib' directory will be loaded before nanoc starts compiling.
# Think of these as utility functions that we can access when writing compilation, routing and layout logic.

include Nanoc::Helpers::Blogging
include Nanoc::Helpers::LinkTo


# A 'short name' for a blog post, suitable for forming part of a URL.  It
# doesn't have to be unique, but it should be unique per date.
def ShortBlogName(item)
  title = item[item.attributes.has_key?(:short_url) ? :short_url : :title]
  title.split(%r{\W+}).join('_')
end

# Custom logic for the output directory.
# We put it here so that other helpers can reference this logic too.
def OutputDirectory(item)
  if item.nil?
    return ''
  end
  case item.identifier
  when %r{/blog/.+}
    root = item.attributes.has_key?(:created_at) ?
      attribute_to_time(item[:created_at]).strftime('/blog/%Y/%m/%d') : '/draft'
    return [root, ShortBlogName(item)].join('/')
  else
    return item.identifier
  end
end

# Links to extra assets (javascript and CSS) requested in the yaml header.
def extra_asset_links
  lines = []
  if item.attributes.has_key?(:css)
    for stylesheet in item.attributes[:css]
      lines.push("<link href='/assets/css/#{stylesheet}.css'"+
                 " type='text/css' rel='stylesheet'>")
    end
  end
  if item.attributes.has_key?(:js)
    for script in item.attributes[:js]
      lines.push("<script type='text/javascript'" +
                 " src='/assets/js/#{script}.js'></script>")
    end
  end
  lines.join("\n")
end
