package dao;

public class Accounts {
    private String user;
    private String password;
    private String name;
    private String createTime;
    private String profilePhoto;
    private Integer checkIn;
    private Integer isBan;
    private String BanEndTime;
    private Integer isAdmin;
    private Integer isChecked;
    private String email;

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Integer getIsChecked() {
        return isChecked;
    }
    public void setIsChecked(Integer isChecked) {
        this.isChecked = isChecked;
    }
    public String getPassword() { return password; }
    public void setPassword(String password) {
        this.password = password;
    }
    public String getUser() {
        return user;
    }
    public void setUser(String user) {
        this.user = user;
    }
    public Integer getCheckIn() {
        return checkIn;
    }
    public void setCheckIn(Integer checkIn) {
        this.checkIn = checkIn;
    }
    public Integer getIsBan() {
        return isBan;
    }
    public void setIsBan(Integer isBan) {
        this.isBan = isBan;
    }
    public Integer getIsAdmin() {
        return isAdmin;
    }
    public void setIsAdmin(Integer isAdmin) {
        this.isAdmin = isAdmin;
    }
    public String getBanEndTime() {
        return BanEndTime;
    }
    public void setBanEndTime(String banEndTime) {
        BanEndTime = banEndTime;
    }
    public String getCreateTime() {
        return createTime;
    }
    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getProfilePhoto() { return profilePhoto; }
    public void setProfilePhoto(String profilePhoto) { this.profilePhoto = profilePhoto; }
}
