require 'open-uri'
require 'nokogiri'

@reserve_days = [28, 29, 30]

def reserved_dai2ordai3?(doc, parking_num, day) 
    index = 0
    if parking_num == 2
        index = 1 #td index
    elsif parking_num == 3
        index = 3 #td index
    end
    doc.css("#guide_01 table tr")[2].css("td")[index].css(".calday").each do |dom| 
        if dom.text == "#{day}"
            return dom.attribute("class").value.include?("bgRed")
        end
    end
end

def reserved_dai4?(doc, day) 
    doc.css("#calendar01 table.calendar_waku td").each do |dom| 
        if dom.text == "#{day}"
            return dom.attribute("class").value.include?("full")
        end
    end
end

def can_reserve?(parking_num, days)
    if parking_num == 4 
        doc = make_doc('https://haneda-p4.jp/airport/entrance/0000.jsf')
        days.each do |day|
            if reserved_dai4?(doc, day)
                return false
            end
        end 
    else
        doc = make_doc('https://hnd-rsv.aeif.or.jp/airport/entrance/0000.jsf')
        days.each do |day|
            if reserved_dai2ordai3?(doc, parking_num, day)
                return false
            end
        end 
    end
    return true
end

def make_doc(url)
    charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end
    
    doc = Nokogiri::HTML.parse(html, nil, charset)
end

# dai2
p can_reserve?(2, @reserve_days)

# dai3
p can_reserve?(3, @reserve_days)

# dai4
p can_reserve?(4, @reserve_days)
