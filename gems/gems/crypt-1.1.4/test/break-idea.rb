# break-idea.rb  Richard Kernahan <kernighan_rich@rubyforge.org>
# prove that IDEA is broken and try to find out why

require 'crypt/idea'
require 'crypt/blowfish'

# generate evidence for defect in IDEA implementation
#  idea_en = Crypt::IDEA.new("Who is John Galt", Crypt::IDEA::ENCRYPT)
#  idea_de = Crypt::IDEA.new("Who is John Galt", Crypt::IDEA::DECRYPT)
#  srand()
#  puts "Finding pairs that fail to encrypt:"
#  while(true) 
#    origL = rand(Crypt::IDEA::ULONG)
#    origR = rand(Crypt::IDEA::ULONG)
#    cl, cr = idea_en.crypt_pair(origL, origR)
#    dl, dr = idea_de.crypt_pair(cl, cr)
#    if ((origL != dl) | (origR != dr))
#      cl, cr = idea_en.crypt_pair(origL, origR)
#      dl, dr = idea_de.crypt_pair(cl, cr)
#      if ((origL != dl) | (origR != dr))
#       printf("[0x%-9x , 0x%-9x]\n", origL, origR)
#       $stdout.flush()
#      end
#    end
#  end
#  fatalPairs = [
#    [0x5bb809a4, 0x804d4aba ],
#    [0xead99b1 , 0xf64a62dd ],
#    [0x50d72345, 0x4f6036d9 ],
#    [0x32d41b94, 0x796a2eb5 ],
#    [0x5d8a606e, 0x33befad  ],
#    [0x87b9dd21, 0xf5d9e7ce ],
#    [0xd96be22c, 0x68fe08c9 ],
#    [0x452131e8, 0xe687bd5  ],
#    [0x827d9308, 0x512ace3d ],
#    [0x5f0931d1, 0xb3b5c5c1 ],
#    [0xd6dc1475, 0xf8964e8b ],
#    [0xb7d7bba6, 0x8b8652e9 ],
#    [0x2f42b24b, 0x6a889e95 ],
#    [0x4e6eaebb, 0x99816f1  ]
#  ]
#  fatalPairs.each { |pair|
#    origL, origR = pair
#    cl, cr = idea_en.crypt_pair(origL, origR)
#    dl, dr = idea_de.crypt_pair(cl, cr)
#    if ((origL != dl) | (origR != dr))
#      puts "still broken"
#    end
#  }
#idea = Crypt::IDEA.new("Who is John Galt", Crypt::IDEA::ENCRYPT)
#(-3..0x10003).each { |a|
#  inv = idea.mulInv(a)
#  product = idea.mul(a, inv)
#  if product != 1
#    puts "a=#{a}  inv=#{inv} mul(a,inv)=#{product}"
#    $stdout.flush()
#  end
#}



