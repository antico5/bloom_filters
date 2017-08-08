require 'rspec'
require 'objspace'
require 'pry'
require_relative '../bloom_filters'

describe BloomFilterSet do
  subject do
    BloomFilterSet.new words.count
  end

  let(:words) { File.read('/usr/share/dict/words').split("\n") }

  it "allows to add a string to the set" do
    subject.add "hello"
  end

  it 'can test if a string belongs to the set' do
    subject.add "hello"
    expect(subject.include? "hello").to be_truthy
  end

  it 'performs with 100 thousand items' do
    100_000.times do |i|
      subject.add i.to_s
    end

    100_000.times do |i|
      expect(subject.include? rand(100_000).to_s).to be_truthy
    end
  end

  it 'performs with all the dictionary words' do
    words.each do |word|
      subject.add word
      expect(subject.include? word).to be_truthy
    end
  end

  it 'show the false positives' do
    falses = 0

    words.each { |word| subject.add word }

    10_000.times do
      if subject.include?(rand.to_s)
        falses += 1
      end
    end
    puts "False positives: #{ falses / 100.0 }%"
  end
end
