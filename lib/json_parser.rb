class JsonParser
  def self.start json
    list = [json]
    i = 0
    while item = list[i]
      if item.is_a? Hash
        item.each do |key, value|
          if value.is_a? Hash
            list.push item.delete(key)
          elsif value.is_a? Array
            value.each do |el|
              list.push el
            end
            item.delete(key)
          end
        end
      elsif item.is_a? Array
        item.each do |el|
          list.push el
        end
      end
      i += 1
    end

    list.select! do |item|
      item.is_a?(Hash) && !item.empty?
    end
    list
  end
end



