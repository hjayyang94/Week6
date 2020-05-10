def read_file(path_to_file, func)
    data = []
    if(!path_to_file.instance_of? String or path_to_file.length < 1)
        puts "Input for path to file incorrect"
    end

    begin
        data = File.read(path_to_file).split(/[\W_]+/).map(&:downcase)
    rescue
        puts "Could not open File"
    ensure
        method(func).call(data, :frequencies)
    end
end


def remove_stop_words(word_list, func)
    stop_words = []
    begin
        stop_words = File.read("../stop_words.txt").split(",")
        stop_words.concat(Array("a".."z"))
    rescue
        puts "Could not open stop words File"
        stop_words = Array("a".."z")
    ensure
        word_list_filtered = word_list.select{|word| !stop_words.include? word}
        method(func).call(word_list_filtered, :sortWords)
    end
end

def frequencies(word_list_filtered, func)
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
    method(func).call(word_freqs.sort_by{|word, count| -count})
end

def printResults(results)
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

