#!/usr/bin/env ruby

def shecho(cmd)
  puts "$ #{cmd}"
  `#{cmd}`
end


def databases
  ['colador_devel', 'colador_test']
end

def create_dbs
  databases.each do |db|
    shecho("psql template1 -c 'create database #{db};'")
  end
end

def run(migration)
  databases.each do |db|
    shecho("psql -f #{migration} #{db} -Ucolador -hlocalhost")
  end
end

run ARGV[0]