module QuerydataHelper
  
  def cumulate(data)
    for i in 0 ... data.size
      sum = 0;
      for j in 0 ... data[i].size
        sum += data[i][j]["y"]
        data[i][j]["y"] = sum
      end
    end
    return data
  end

end
