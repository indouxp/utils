//
// やさしいXML 第三版 P. xiii
//
import java.io.*;
import javax.xml.*;
import javax.xml.transform.stream.*;
import javax.xml.validation.*;
import org.xml.sax.*;

public class Validate {
  public static void main(String args[]) throws Exception {
    if (args.length != 2) {
      System.out.println("引数1:XML文書名、引数2:XML Schema文書名");
      System.exit(-1);
    }
    StreamSource in = new StreamSource(new File(args[0]));
    StreamSource xs = new StreamSource(new File(args[1]));

    SchemaFactory sf =
      SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
    Schema sc = sf.newSchema(xs);

    Validator vl = sc.newValidator();

    try {
      vl.validate(in);
      System.out.println("妥当な文書です。");
    } catch (SAXException e) {}
    System.exit(0);
  }
}
