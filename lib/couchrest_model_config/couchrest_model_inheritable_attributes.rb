# Copyright (c) 2006-2009 David Heinemeier Hansson
#  
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#  
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#  
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# Extracted From
# http://github.com/rails/rails/commit/971e2438d98326c994ec6d3ef8e37b7e868ed6e2

module CouchRest
  module InheritableAttributes
    
    # Defines class-level inheritable attribute reader. Attributes are available to subclasses,
    # each subclass has a copy of parent's attribute.
    #
    # @param *syms<Array[#to_s]> Array of attributes to define inheritable reader for.
    # @return <Array[#to_s]> Array of attributes converted into inheritable_readers.
    #
    # @api public
    #
    # @todo Do we want to block instance_reader via :instance_reader => false
    # @todo It would be preferable that we do something with a Hash passed in
    #   (error out or do the same as other methods above) instead of silently
    #   moving on). In particular, this makes the return value of this function
    #   less useful.
    def couchrest_inheritable_reader(*ivars)
      instance_reader = ivars.pop[:reader] if ivars.last.is_a?(Hash)
      
      ivars.each do |ivar|
        unless self.respond_to?(ivar.to_sym)
          self.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def self.#{ivar}
              return @#{ivar} if self.object_id == #{self.object_id} || defined?(@#{ivar})
              ivar = superclass.#{ivar}
              return nil if ivar.nil? && !#{self}.instance_variable_defined?("@#{ivar}")
              @#{ivar} = ivar && !ivar.is_a?(Module) && !ivar.is_a?(Numeric) && !ivar.is_a?(TrueClass) && !ivar.is_a?(FalseClass) ? ivar.dup : ivar
            end
          RUBY
        end

        if instance_reader == true && !self.method_defined?(ivar.to_sym)
          self.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{ivar}
              self.class.#{ivar}
            end
          RUBY
        end
      end
    end

    # Defines class-level inheritable attribute writer. Attributes are available to subclasses,
    # each subclass has a copy of parent's attribute.
    #
    # @param *syms<Array[*#to_s, Hash{:instance_writer => Boolean}]> Array of attributes to
    #   define inheritable writer for.
    # @option syms :instance_writer<Boolean> if true, instance-level inheritable attribute writer is defined.
    # @return <Array[#to_s]> An Array of the attributes that were made into inheritable writers.
    #
    # @api public
    #
    # @todo We need a style for class_eval <<-HEREDOC. I'd like to make it
    #   class_eval(<<-RUBY, __FILE__, __LINE__), but we should codify it somewhere.
    def couchrest_inheritable_writer(*ivars)
      instance_writer = ivars.pop[:writer] if ivars.last.is_a?(Hash)
      ivars.each do |ivar|
        unless self.respond_to?("#{ivar}=".to_sym)
          self.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def self.#{ivar}=(obj)
              @#{ivar} = obj
            end
          RUBY
        end
        
        unless self.method_defined?("#{ivar}=".to_sym)
          unless instance_writer == false
            self.class_eval <<-RUBY, __FILE__, __LINE__ + 1
              def #{ivar}=(obj) self.class.#{ivar} = obj end
            RUBY
          end
        end

        self.send("#{ivar}=", yield) if block_given?
      end
    end

    # Defines class-level inheritable attribute accessor. Attributes are available to subclasses,
    # each subclass has a copy of parent's attribute.
    #
    # @param *syms<Array[*#to_s, Hash{:instance_writer => Boolean}]> Array of attributes to
    #   define inheritable accessor for.
    # @option syms :instance_writer<Boolean> if true, instance-level inheritable attribute writer is defined.
    # @return <Array[#to_s]> An Array of attributes turned into inheritable accessors.
    #
    # @api public
    def couchrest_inheritable_accessor(*syms, &block)
      couchrest_inheritable_reader(*syms)
      couchrest_inheritable_writer(*syms, &block)
    end
  end
end
