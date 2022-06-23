
def abs(x)
    if(x<0)
        -1*x
    else
        x
    end
end


class Function2D
    def initialize(block,accuaracy=0.01)
        @foo = block
        @acc = accuaracy
    end

    def value(x,y)
        @foo.call(x,y)
    end

    def volume(a, b, c, d) 
        res = 0 
        h1=(abs((b-a)))/100
        h2=(abs(d-c))/100

        $i = a
        until $i > b do
            $j = c
            until $j > d do
                res+=(value($i,$j)+value($i+h1,$j)+ value($i,$j+h2)+value($i+h1,$j+h2))/4*h1*h2
                $j+=h2
            end
            $i +=h1
        end
        res
    end

    
    def contour_line(a, b, c, d, height)
        res= Array.new
        counter=0
        $i = a
        until $i >= b do
            $j = c
            until $j >= d do
                if(abs(value($i,$j)-height) <= @acc)
                    res[counter] = [$i,$j]
                    counter+=1
                end
                $j +=@acc
            end
            $i +=@acc
        end
        res
    end



    ##do zadanie nr 3


    def create_Script(name)
        file_script = File.new("graph.p","w")
        file_script.puts("set terminal png")
        file_script.puts("set output '" + name + ".png'")
        file_script.puts("set hidden3d")
        file_script.puts("set xyplane at 0")
        file_script.puts("splot '"+name+".txt'" + " with lines palette")
        file_script.close()
    end

    def graph(name="graph",xmin=-5,xmax=5,ymin=-5,ymax=5)  
        file_data = File.new(name+".txt", "w")
        file_data.puts("# X Y Val")
        
        $i = xmin
        until $i >= xmax do
            $j = ymin
            until $j >= ymax do
                file_data.puts($i.to_s + ' ' + $j.to_s + ' ' +value($i,$j).to_s)
                $j +=@acc
            end
            $i +=@acc
        end
        file_data.close
        #creating script: 
        create_Script(name)
   end
end


block = proc {|x,y| x*x + y*y}
test = Function2D.new(block,0.1) #
temp = test.contour_line(-3,5,-5,5,55)
temp2 = test.contour_line(-3,5,-5,5,49)
puts(temp.to_s)
puts(temp2.to_s)
puts(test.volume(-5,-4.999,-0.5,0.5).to_s)
puts(test.volume(-5,-4.5,-0.5,0.5).to_s)
#test.graph()


=begin
block2 = proc {|x,y| Math.sqrt(x*x+y*y)}
test2 = Function2D.new(block2)
test2.graph("Cone",-15,15,-15,15)
=end

#aby stworzyc wykres wystarczy wywolac metode graph() dla obiektu klasy Function2D. 
#Utworzony zostanie skrypt graph.p ktory po uruchomieniu przy pomocy gmuplot, stworzy plik .png z wykresem