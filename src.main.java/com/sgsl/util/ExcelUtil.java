package com.sgsl.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.sgsl.model.TUser;

public class ExcelUtil {
	/**
	 * excel导入
	 * @param filePath 文件路径
	 * @param fileName 文件名
	 * @param sheetIndex sheet位置 0开始
	 * @param rowStartIndex 行号 0开始
	 * @param colStartIndex 列号0开始
	 * @param colEndIndex  列结束 结束的列 例如D传3
	 */
	public static String[][] importExcel(String filePath,String fileName,int sheetIndex,
			int rowStartIndex,int colStartIndex,int colEndIndex){
		Sheet sheet=null;
		String result [][]=null;
		try {
			sheet = new XSSFWorkbook(new FileInputStream(filePath+fileName))
					.getSheetAt(sheetIndex);
		
			int rowNum = sheet.getLastRowNum();
			result=new String[rowNum-rowStartIndex+1][];
			int y=0;
			//循环行
			for(int i =rowStartIndex; i <= rowNum; i++) {
				
				Row row = sheet.getRow(i);
				String item[]=new String[colEndIndex-colStartIndex+1];
				if(row == null){
					break;
				}
				//循环列
				int x=0;
				for (int j = colStartIndex; j <= colEndIndex; j++) {
					Cell cell = row.getCell(j);
					item[x++]=cell.getStringCellValue();
				}	
				result[y++]=item;
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * excel获取列数据
	 * @param filePath
	 * @return
	 */
	public static List<String> getColData(String filePath){
		List<String> data = new ArrayList<String>();
		// 读取发放名单
		try {
			XSSFWorkbook wookbook = new XSSFWorkbook(new FileInputStream(filePath));
			// 得到sheet1
			XSSFSheet sheet = wookbook.getSheet("Sheet1");
			// 得到总行数
			int rows = sheet.getPhysicalNumberOfRows();
			//Object[][] paras = new Object[rows][1];
			
			// 遍历行
			for (int i = 1; i < rows; i++) {
				// 获取当前行
				XSSFRow row = sheet.getRow(i);
				if (row != null) {
					// 获取当前行中的cell数
					// int cells = row.getPhysicalNumberOfCells();
					// 拿取第一列，设定好第一列数据为电话号码
					XSSFCell cell = row.getCell(0);
					// 格式不是文本，跳出本次循环
					if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
						System.out.println("excel表格电话号码列不是文本格式");
						continue;
					}
					String phone_number = cell.getStringCellValue();
					data.add(phone_number);
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return data;
	}
	
	public static void main(String[] args) {
		String[][] r=ExcelUtil.importExcel("D:\\Users\\User\\Desktop\\", "门店基础信息(1).xlsx", 1, 
				0, 0, 3);
		for(int i=0;i<r.length;i++){
			
			for(int j=0;j<r[i].length;j++){
				System.out.print(r[i][j]);
			}
			System.out.println();
		}
	}
	
	public void cpoy(String source, String target) throws Exception {   
		FileOutputStream output = new FileOutputStream(new File(target));
		Workbook workbook = new XSSFWorkbook();            
		Sheet targetSheet = workbook.createSheet("sheet1");  
		Sheet sheet = new XSSFWorkbook(new FileInputStream(source)).getSheetAt(0);
		int rowNum = sheet.getLastRowNum();
		for (int i = 0; i < rowNum; i++) {
			Row row = sheet.getRow(i);
			if(row == null){
				continue;
			}
			Row newRow = targetSheet.createRow(i);
			int num = row.getLastCellNum();
			for (int j = 0; j < num; j++) {
				Cell newCell = newRow.createCell(j);
				Cell cell = row.getCell(j);
				if(cell == null){
					newCell.setCellValue("");
				}else{
					newCell.setCellType(cell.getCellType());
					if(j == 12){
						String value = cell.getStringCellValue().trim();
						/*if(!StringUtil.isBlank(value)){
							try {
								value = DES.decrypt(value, key);
							} catch (Exception e) {
								
							}
							newCell.setCellValue(value);
						}*/
					}else{
						newCell.setCellValue(cell.getStringCellValue());
					}
				}
			}
		}
		workbook.write(output);  
        output.close();   
	}
}
