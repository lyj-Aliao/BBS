package service;
import java.awt.Image;
import javax.imageio.ImageIO;
import java.awt.image.*;
import java.io.File;
import java.awt.Toolkit;
import java.awt.Graphics;

public class CutPicture {
    /**
     *  缩放后裁剪图片方法
     * @param srcImageFile 源文件
     * @param x  x坐标
     * @param y  y坐标
     * @param srcMillsFile  按毫秒保存文件名
     * @param destWidth 最终生成的图片宽
     * @param destHeight 最终生成的图片高
     * @param finalWidth  缩放宽度
     * @param finalHeight  缩放高度
     */
    public static void abscut(String srcImageFile, String srcMillsFile, int x, int y, int destWidth, int destHeight, int finalWidth, int finalHeight) {
        try {
            Image img;
            ImageFilter cropFilter;
            // 读取源图像
            BufferedImage bi = ImageIO.read(new File(srcImageFile));
            // 源图宽度
            int srcWidth = bi.getWidth();
            // 源图高度
            int srcHeight = bi.getHeight();
            if (srcWidth >= destWidth && srcHeight >= destHeight) {
                //获取缩放后的图片大小
                Image image = bi.getScaledInstance(finalWidth, finalHeight,Image.SCALE_DEFAULT);

                cropFilter = new CropImageFilter(x, y, destWidth, destHeight);
                img = Toolkit.getDefaultToolkit().createImage(new FilteredImageSource(image.getSource(), cropFilter));
                BufferedImage tag = new BufferedImage(destWidth, destHeight, BufferedImage.TYPE_INT_RGB);
                Graphics g = tag.getGraphics();
                // 绘制截取后的图
                g.drawImage(img, 0, 0, null);

                g.dispose();
                // 输出为文件
                if (srcMillsFile != null){
                    ImageIO.write(tag, "JPEG", new File(srcMillsFile));
                }else{
                    ImageIO.write(tag, "JPEG", new File(srcImageFile));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
