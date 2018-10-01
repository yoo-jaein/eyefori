class NokogiriController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  require 'uri'
  
  def region
    sido = 0
    
    begin
    # 한글을 제외한 주소
    url1 = "http://api.childcare.go.kr/mediate/rest/cpmsapi020/cpmsapi020/request?key=20f62935a253418bb0ed6c8601934b7d&arname="
    
    # 주소에 들어갈 시도의 이름
    if(sido==0)
      url2 = "서울"
    elsif(sido==1)
      url2 = "인천"
    elsif(sido==2)
      url2 = "경기도"
    elsif(sido==3)
      url2 = "강원도"
    elsif(sido==4)
      url2 = "충청남도"
    elsif(sido==5)
      url2 = "충청북도"
    elsif(sido==6)
      url2 = "대전"
    elsif(sido==7)
      url2 = "세종"
    elsif(sido==8)
      url2 = "경상북도"
    elsif(sido==9)
      url2 = "대구"
    elsif(sido==10)
      url2 = "울산"
    elsif(sido==11)
      url2 = "경상남도"
    elsif(sido==12)
      url2 = "부산"
    elsif(sido==13)
      url2 = "전라북도"
    elsif(sido==14)
      url2 = "광주"
    elsif(sido==15)
      url2 = "전라남도"
    elsif(sido==16)
      url2 = "제주"
    end
    
    # 전체 url
    url = URI.encode(url1+url2)
    doc = Nokogiri::XML(open(url))
  
    # item 파싱
    item = doc.xpath("//item")
    
    counter = 0
    
    # item 내부 정보 하나씩 꺼내기
    item.each do |i|
      @region = Region.new
      
      members = i.xpath("//sidoname")[counter]
      @region.sidoname = members.inner_text
      
      members = i.xpath("//sigunname")[counter]
      @region.sigunname = members.inner_text
      
      members = i.xpath("//arcode")[counter]
      @region.arcode = members.inner_text
      
      @region.save
      counter += 1
    end
    
    sido +=1
    end while sido <=16

  end
  
  def frequent
    require 'rubygems'
    require 'json'
    require 'pp'
    
    # 서울광역시 전체 선택
    url = "http://apis.data.go.kr/B552061/frequentzoneChild/getRestFrequentzoneChild?servicekey=aAkkQBvnhPvUEXEGqcHEPZYWN8h%2FLqcMChpZFlMdeOtp6jaYY9WdrxfvGAsPNr%2BYrFO0GdlY1GKLVMNKX%2FeHlw%3D%3D&searchYearCd=2017027&siDo=11&guGun="
    
    doc = JSON.parse(open(url).read)
    # pp doc
    
    # TotalCount 11
    result = doc['searchResult']['frequentzone']
    
    (0..10).each do |i|
      @frequent = Frequent.new
      
      @frequent.spotname =  result[i]['spotname']
      # 위도 경도
      @frequent.x_crd = result[i]['x_crd']
      @frequent.y_crd =  result[i]['y_crd']
      
      @frequent.save
    end
  end
end
