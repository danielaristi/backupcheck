buzzwords = ['Paradigm shift', 'Leverage', 'Pivoting', 'Turn-key', 'Streamlininess', 'Exit strategy', 'Synergy', 'Enterprise', 'Web 2.0'] 
buzzword_counts = Hash.new({ value: 0 })

SCHEDULER.every '2s' do
  random_buzzword = buzzwords.sample
  buzzword_counts[random_buzzword] = { label: random_buzzword, value: (buzzword_counts[random_buzzword][:value] + 1) % 30 }
  
  p buzzword_counts.values	

 p	 buzzword_counts

x={:label=>"abcdin31", :value=>1}


#  send_event('buzzwords', { items: buzzword_counts.values })
  send_event('buzzwords', { items: x })





end