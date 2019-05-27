package example;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.junit.After;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.web.server.LocalServerPort;
import org.springframework.test.context.junit4.SpringRunner;

import static org.hamcrest.CoreMatchers.containsString;
import static org.hamcrest.MatcherAssert.assertThat;

@RunWith(SpringRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class HelloE2ESeleniumTest {

    // private static String chromeVersion = "74";
    // private WebDriver driver;

    // @LocalServerPort
    // private int port;

    // @BeforeClass
    // public static void setUpClass() throws Exception {
    //     WebDriverManager.chromedriver().version(chromeVersion).setup();
    // }

    // @Before
    // public void setUp() throws Exception {

    //     ChromeOptions chromeOptions = new ChromeOptions();
    //     chromeOptions.addArguments("--headless");
    //     chromeOptions.addArguments("--disable-gpu");
    //     chromeOptions.addArguments("--privileged");

    //     driver = new ChromeDriver(chromeOptions);
    // }

    // @After
    // public void tearDown() {
    //     if (driver != null) {
    //         driver.quit();
    //     }
    // }

    // @Test
    // public void helloPageHasTextHelloWorld() {
    //     driver.navigate().to(String.format("http://localhost:%s/hello", port));

    //     WebElement body = driver.findElement(By.tagName("body"));

    //     assertThat(body.getText(), containsString("Hello World!"));
    // }
}
