<#include "/WEB-INF/pages/common/_layout_admin_pc.ftl"/>
<@layout scripts=["/js/upload.js","/js/ajaxfileupload.js"] styles=[]>


			<form id="uploadForm"  action="" method="post" enctype="multipart/form-data" >
				
				<!-- <div class="form-group">
					 <input id="exampleInputFile" type="file" name="upfile"  />
				</div> -->
				
				<input id="exampleInputFile" type="file" size="30" name="exampleInputFile" multiple />

				
				<button type="submit" class="btn btn-default">Submit</button>
				
					<td><button class="button" id="buttonUpload" onclick="return ajaxFileUpload();">Upload</button></td>
				
				<br>

			
				
			</form> 

</@layout>
