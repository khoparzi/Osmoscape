import java.util.Arrays;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

String parseString(String input) {
  if (input.equalsIgnoreCase("null")) {
    return "null";
  }

  String s = input.trim();
  // 3. check if data is an Integer (4-byte integer with range [-(2e31), (2e31)-1])
  try {
    Integer i = Integer.parseInt(s); return "int";
    // if we make it to this line, the data parsed fine as an Integer
  } catch (java.lang.NumberFormatException ex) {
    // okay, guess it's not an Integer
  }

  String s_L_trimmed = s;

  // 4. check if data is a Long (8-byte integer with range [-(2e63), (2e63)-1])

  try {
    //    ...first, see if the last character of the string is "L" or "l"
    if (Arrays.asList("L", "l").contains(s.substring(s.length() - 1)) && s.length() > 1)
      s_L_trimmed = s.substring(0, s.length() - 1);

    Long l = Long.parseLong(s_L_trimmed); return "long";
    // if we make it to this line, the data parsed fine as a Long
  } catch (java.lang.NumberFormatException ex) {
    // okay, guess it's not a Long
  } catch (java.lang.StringIndexOutOfBoundsException ex) {

  }

  // 5. check if data is a Float (32-bit IEEE 754 floating point with approximate extents +/- 3.4028235e38)
  try {
    Float f = Float.parseFloat(s);

    if (!f.isInfinite()) // if it's beyond the range of Float, maybe it's not beyond the range of Double
      return "float";
      // if we make it to this line, the data parsed fine as a Float and is finite

  } catch (java.lang.NumberFormatException ex) {
    // okay, guess it's not a Float
  }

  // 6. check if data is a Double (64-bit IEEE 754 floating point with approximate extents +/- 1.797693134862315e308 )
  try {
    Double d = Double.parseDouble(s);

    if (!d.isInfinite())
      return "double";
      // if we make it to this line, the data parsed fine as a Double
    else // if it's beyond the range of Double, just return HV.newValue(a) String and let the user decide what to do
      return "string";

  } catch (java.lang.NumberFormatException ex) {
    // okay, guess it's not a Double
  }
  return "string";
}

DataTable readCSV(String selection) {
  DataTable rawData = HV.loadSpreadSheet(
    HV.loadSSConfig().sourceFile(sketchFile(selection))
      .headerRowIndex(4).rowIndex(5)
  );

  rawData = rawData.apply(new SeriesFunction() {
    public DataSeries apply(DataSeries inputSeries) {
      int rownum = 0; DataSeries temp = HV.newSeries();
      for (String val : inputSeries.asStringArray()) {
        switch (parseString(val)) {
          case "null":
            temp.append(0.0f);
            break;
          case "int":
            temp.append(Integer.parseInt(val));
            break;
          case "long":
            temp.append(Long.parseLong(val));
            break;
          case "float":
            temp.append(Float.parseFloat(val));
            break;
          case "double":
            temp.append(Double.parseDouble(val));
            break;
          case "string":
            temp.append(val);
            break;
        }

        rownum++;
      }
      return temp;
    }
  });

  println("RAW DATA");
  println(rawData);
  return rawData;
}

DataTable readCSV(String selection, int endCol) {
  // If specified end column is positive read till that column
  if (endCol > 0)
    return readCSV(selection).selectSeriesRange(0, endCol);
  // Else cutoff of the number of specified columns from the end
  else {
    DataTable rawData = readCSV(selection);
    return rawData.selectSeriesRange(0, rawData.seriesCount() + endCol);
  }
}

DataTable readCSV(String selection, int[] colSel) {
  DataTable rawData = readCSV(selection);
  DataTable cropTable = HV.newTable();
  if (colSel[0] > 0 && colSel.length > 3)
   cropTable = cropTable.addSeries(rawData.selectSeries(0));

  // If specified end column is positive read till that column
  if (colSel[1] > 0)
    return cropTable.combine(
      rawData.selectSeriesRange(colSel[0], colSel[1]));
  // Else cutoff of the number of specified columns from the end
  else {
    return cropTable.combine(
      rawData.selectSeriesRange(colSel[0], rawData.seriesCount() + colSel[1]));
  }
}

DataTable readCSV(String selection, String scalingType) {
  DataTable dataRange = readCSV(selection);
  return scaledCSV(dataRange, scalingType);
}

DataTable readCSV(String selection, int endCol, String scalingType) {
  DataTable dataRange = readCSV(selection, endCol);
  return scaledCSV(dataRange, scalingType);
}

DataTable scaledCSV(DataTable dataRange, String scaling) {
  DataTable scaledData = HV.newTable();

  if (scaling.equals("unit")) {
    // Move to unit range
    scaledData = dataRange.apply(new SeriesFunction() {
      public DataSeries apply(DataSeries inputSeries) {
        return inputSeries.isNumeric() ? inputSeries.toUnitRange() : inputSeries;
      }
    });
  } else if (scaling.equals("scaled")) {
    scaledData = dataRange.apply(new SeriesFunction() {
      public DataSeries apply(DataSeries inputSeries) {
        return inputSeries.isNumeric() ? inputSeries.toRange(0, highY) : inputSeries;
      }
    });
    scaling = scaling + " to " + highY;
  } else if (scaling.equals("divided")) {
    scaledData = dataRange.apply(new SeriesFunction() {
      public DataSeries apply(DataSeries inputSeries) {
        return inputSeries.isNumeric() ? inputSeries.divide(100) : inputSeries;
      }
    });
    scaling = " divided by 100";
  }

  println("PROCESSED DATA WITH "+scaling);
  println(scaledData);
  return scaledData;
}
