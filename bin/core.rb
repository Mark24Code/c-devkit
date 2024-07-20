# frozen_string_literal: true
require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem "pkg-config", "~> 1.5"
end

require "pkg-config"

class ClibError < StandardError

end

class CLibManager
  attr_accessor :libs
  def initialize
    @name = nil
    @entry = "main.c"
    @version = nil
    @repo = nil
    @libs = []
    @ccompiler = "gcc"
    @commands = {}
    @output = @name

    @include_cflags = []
    @libs_cflags = []

  end

  def setup
    register :install
    register :uninstall
    register :build
    register :run
  end

  def ccompiler(cc = nil)
    @ccompiler = cc || "gcc"
  end

  def entry(entry_file_name)
    @entry = entry_file_name
  end

  def output(output_file_name)
    @output = output_file_name
  end

  def name(name)
    @name = name
  end

  def version(version_string)
    @version = version_string
  end

  def repo(repo_url)
    @repo = repo_url
  end

  def lib(name, version = nil)
    @libs.push(name)
  end

  def include_cflags(flag)
    @include_cflags << flag
  end

  def libs_cflags(flag)
    @libs_cflags << flag
  end

  def dependencies(&block)
    if block_given?
       yield block
    end
  end



  def make_libs_flags
    flags = []
    @libs.each do |lib_name|
      lib = PackageConfig.new(lib_name)
      if !lib.exist?
        raise ClibError, "[Error] lib: `#{lib_name}` not found!"
      end

      flags << lib.libs
    end

    flags + @libs_cflags
  end


  def make_include_cflags
    flags = []
    @libs.each do |lib_name|
      lib = PackageConfig.new(lib_name)
      if !lib.exist?
        raise ClibError, "[Error] lib: `#{lib_name}` not found!"
      end

      flags << lib.cflags
    end

    flags + @include_cflags
  end


  def command(command_name, &block)
    if block_given?
      @commands[command_name.to_s] = block
    end
  end

  def run
    build
    system(@output)
  end
  alias :previw :run

  def eval_code(code)
    instance_eval(code)
    setup
  end

  def run_command(command_name)
    @commands[command_name.to_s].call
  end

  def register(command)
    @commands[command.to_s] = method(command)
  end

  def install
    libs = @libs.join(" ")
    system("brew install #{libs}")
  end

  def uninstall
    libs = @libs.join(" ")
    system("brew uninstall #{libs}")
  end

  def build
    @output = @output || @name

    output = @output.split("/")
    output.pop

    output_dir = output.join("/")
    `mkdir -p #{output_dir}`

    cmd = "#{@ccompiler} #{make_include_cflags.join(" ")} #{make_libs_flags.join(" ")} src/*.c -o #{@output}"
    puts "[build] #{cmd}"
    system(cmd)
  end
end
