#!/usr/bin/env ruby

require 'gruff'
require 'yaml'

puts "Usage: ruby gcaga.rb gene_pres_matrix.txt"

class Cluster
  attr_accessor :presence_list, :name
end

strains = []
all_clusters = []

puts ARGF.filename

File.open(ARGF.filename).each do |line|
	if $. == 1
		strains = line.split.drop(1)
		puts strains.join(" ")
	else
		c = Cluster.new
		presence = line.split
		c.name = presence.shift
		c.presence_list = {}
		(0..strains.length-1).each do |s|
			c.presence_list[strains[s]] = presence[s].to_i
		end
		all_clusters.push(c)
		#puts c.presence_list.to_yaml unless $. > 3
	end
end


puts "Strain_added total core dist"
(0..strains.length-1).each do |s|
	totals = {
		genome_added: strains[s],
		total_clusts: 0,
		core_clusts: 0,
		dist_clusts: 0
	}

	all_clusters.each do |c|
		count = 0
		(0..s).each do |g|
			#puts c.presence_list[strains[g]]
			count += c.presence_list[strains[g]]
		end
		if count == s + 1
			totals[:total_clusts] += 1
			totals[:core_clusts] += 1
		elsif count != 0 && count <= s + 1
			totals[:dist_clusts] += 1
			totals[:total_clusts] +=1
		end
				
	end
	puts totals[:genome_added] + " " + totals[:total_clusts].to_s + " "+ totals[:core_clusts].to_s + " " + totals[:dist_clusts].to_s
end

