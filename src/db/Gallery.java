package db;

public class Gallery {
	private int gallery_id;
	private String gallery_fileTitle;
	private String gallery_fileName;
	private String gallery_RegDate;
	
	public int getGallery_id() {
		return gallery_id;
	}
	public String getGallery_fileTitle() {
		return gallery_fileTitle;
	}
	public String getGallery_fileName() {
		return gallery_fileName;
	}
	public String getGallery_RegDate() {
		return gallery_RegDate;
	}
	public void setGallery_id(int gallery_id) {
		this.gallery_id = gallery_id;
	}
	public void setGallery_fileTitle(String gallery_fileTitle) {
		this.gallery_fileTitle = gallery_fileTitle;
	}
	public void setGallery_fileName(String gallery_fileName) {
		this.gallery_fileName = gallery_fileName;
	}
	public void setGallery_RegDate(String gallery_RegDate) {
		this.gallery_RegDate = gallery_RegDate;
	}
	
	
}
