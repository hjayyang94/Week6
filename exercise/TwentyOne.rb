def read_file(path_to_file, func)
    data = []
    if(!path_to_file.instance_of? String or path_to_file.length < 1)
        raise Exception.new "Function {read_file} encountered an error for path to file input"
        exit
    end

    begin
        data = File.read(path_to_file).split(/[\W_]+/).map(&:downcase)
        method(func).call(data, :frequencies)
    rescue
        raise Exception.new "Function {read_file} could not open File"
        exit
    end
    
end


def remove_stop_words(word_list, func)
    stop_words = []
    begin
        stop_words = File.read("../stop_words.txt").split(",")
        stop_words.concat(Array("a".."z"))
        word_list_filtered = word_list.select{|word| !stop_words.include? word}
        method(func).call(word_list_filtered, :sortWords)
    rescue
        raise Exception.new "Function {remove_stop_words} could not open the stop words txt file!"
        exit
    end
end

def frequencies(word_list_filtered, func)
    if (word_list_filtered.class != Array)
        raise Exception.new "Function {Frequencies} only takes an {Array} as a parameter!"
        exit
    end
    word_freqs = {}

    word_list_filtered.each do |word|
        if !word_freqs.include? word
            word_freqs[word] = 1
        else
            word_freqs[word] = word_freqs[word]+1
        end
    end

    method(func).call(word_freqs,:printResults)
end

def sortWords(word_freqs, func)
    if (word_freqs.class != Hash)
        raise Exception.new "Function {sortWords} only takes {Hashes}!"
        exit
    end
    method(func).call(word_freqs.sort_by{|word, count| -count})
end

def printResults(results)
    if (results.class != Array)
        raise Exception.new "Function {printResults} only takes {Hashes}!"
        exit
    elsif (results.length < 25)
        raise Exception.new "{Results} has less than 25 results!"
        exit
    end

    puts "---------Results-----------"
    for (w, c) in results[0..25]
        puts( w+ " - "+ c.to_s)
    end
    puts "-----------End-------------"
end

path_to_file = ""
if (ARGV[0] != nil)
    path_to_file = ARGV[0]
else
    path_to_file = "../input.txt"
end

read_file(path_to_file, :remove_stop_words)

