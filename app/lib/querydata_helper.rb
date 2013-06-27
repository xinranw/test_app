module QuerydataHelper
  
  def cumulate(data, params)
    if (params[:constants][:ser_value] == "rev")
      y = "PROFIT"
    elsif (params[:constants][:ser_value] == "num")
      y = "NUMBER_OF"
    end

    for i in 0 ... data.size
      sum = 0;
      for j in 0 ... data[i].size
        sum += data[i][j][y]
        data[i][j][y] = sum
      end
    end
    return data
  end

end
