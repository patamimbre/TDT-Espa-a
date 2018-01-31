require 'json'
require 'httparty'
require 'argv'


class TvSpain

    attr_reader :channels

    def initialize
        updateChannels()
        #printChannels(true)
    end


    def updateChannels
        url = "https://raw.githubusercontent.com/ruvelro/TV-Online-TDT-Spain/master/tv-spain.json"
        resp = HTTParty.get (url)
        @channels = JSON(resp.parsed_response)
    end

    def printChannels(links = false)
        @channels.each do |ch|
            if links
                p "#{ch['id']} - #{ch['name']}  #{ch['link_m3u8']}"
            else
                p "#{ch['id']} - #{ch['name']}"
            end
        end
        p '·'*30
    end


end


class App
    def initialize
        @tv = TvSpain.new
        parseARG()
        launchChannel() unless @canal.nil?
    end


    private
    
    def parseARG
        ARGV.to_hash

        if ARGV.short_options.include? 'l'
            @tv.printChannels
        end

        if ARGV.short_options.include? 'c'
            idcanal = Integer(ARGV.to_hash['c'])
            @canal = @tv.channels.detect { |ch| ch['id']==idcanal}
        else
            printHelp
        end

        if ARGV.short_options.include? 'r'
            @reproductor = ARGV.to_hash['r']
        else
            @reproductor = 'vlc'
        end
    end

    def printHelp
        p "-c <num canal> "
        p "-r <reproductor> (por defecto vlc)"
        p "-l listar canales"
        p "-h ayuda"
        
    end

    def launchChannel
        p " ##{@canal['id']} -> #{@canal['name']}"

        # lanza el canal con el reproductor indicado
        `#{@reproductor} #{@canal['link_m3u8']}`




    end




        
    
end

App.new





