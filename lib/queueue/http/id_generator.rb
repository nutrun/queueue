module Queueue::Http
  module IdGenerator
    def request_id
      chars = ('a'..'z').to_a + ('1'..'9').to_a
      [8, 4, 4, 4, 12].map do |n|
        Array.new(n).map { |e| chars[rand(chars.size)] }.join
      end.join('-')
    end
  end
end