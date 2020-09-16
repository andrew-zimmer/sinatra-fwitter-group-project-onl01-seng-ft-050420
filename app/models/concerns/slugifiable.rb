module Slugable

     module InstanceMethods

          def slug
               self.username.downcase.gsub(" ","-")
          end

     end


end