require "open-uri" 
require "uri"
require "json"
    #如果有GET请求参数直接写在URI地址中  
def sendquest(query)
    uri = URI::escape('http://api.map.baidu.com/place/v2/search?ak=YourKey&output=json&query='+query+'&page_size=1&page_num=0&scope=2&region=北京')
    html_response = nil 
    open(uri) do |http|  
      html_response = http.read  
    end 
    return html_response
end


f = open("lnglat4.txt","w")

Input = IO.readlines("601-900.txt")
i = 2401
Input.each{
	|s|
	s.force_encoding("UTF-8")
	results = sendquest(s)
	#results = results.delete('renderOption&&renderOption(')
	message = JSON.parse(results)
	detail = message["results"][0]
	f.print i
	f.print " #{message["total"]}"
	if detail!=nil
		if detail["name"]!=nil 
			f.print " #{detail["name"]}"
		else 
			f.print " *"
		end
		if detail["location"]!=nil 
			f.print " #{detail["location"]["lng"]},#{detail["location"]["lat"]}"
		else 
			f.print " *"			
		end
		if detail["address"]!=nil 
			f.print " #{detail["address"]}"
		else 
			f.print " *"			
		end
		if detail["address"]!=nil
			add = detail["address"]
		end
		if (add!=nil) && (add.include? "区")
			district = add.split("区")
			f.print " #{district[0].delete("北京市").chomp.chomp}区"
		else
			f.print " *"
		end
		if detail["telephone"]!=nil 
			f.print " #{detail["telephone"]}"
		else 
			f.print " *"			
		end
	end
	f.print "\n"
	#f.puts "#{detail["name"]} #{detail["address"]} #{detail["location"]["lng"]} #{detail["location"]["lat"]}"
	i = i+1
}
