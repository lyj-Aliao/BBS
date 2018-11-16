package dao;

public class Post {
    private Integer id;
    private String title;
    private String comment;
    private String createAccount;
    private String time;
    private Integer priority;
    private Integer clickCount;
    private Integer isHot;

    //获取用户头像
    private String profilePhoto;

    //获取评论数量
    private Integer countByComment;

    public Integer getCountByComment() {
        return countByComment;
    }

    public void setCountByComment(Integer countByComment) {
        this.countByComment = countByComment;
    }

    public void setProfilePhoto(String profilePhoto) {
        this.profilePhoto = profilePhoto;
    }

    public String getProfilePhoto() {
        return profilePhoto;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getComment() {
        return comment;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getTitle() {
        return title;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getId() {
        return id;
    }

    public void setCreateAccount(String createAccount) {
        this.createAccount = createAccount;
    }

    public String getCreateAccount() {
        return createAccount;
    }

    public void setClickCount(Integer clickCount) {
        this.clickCount = clickCount;
    }

    public Integer getClickCount() {
        return clickCount;
    }

    public void setIsHot(Integer isHot) {
        this.isHot = isHot;
    }

    public Integer getIsHot() {
        return isHot;
    }

    public void setPriority(Integer priority) {
        this.priority = priority;
    }

    public Integer getPriority() {
        return priority;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getTime() {
        return time;
    }
}
