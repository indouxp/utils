#
# https://qiita.com/ymk1102_1t/items/42aa7c588ce97e3312b6
#
import datetime
import inspect
import os
import re
from selenium import webdriver
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.common.exceptions import NoSuchElementException
import sys
import time
import traceback

CHROME="/usr/lib/chromium-browser/chromedriver"

# 場所取得
def location(depth=0):
  now = datetime.datetime.now()
  frame = inspect.currentframe().f_back
  return \
      os.path.basename(frame.f_code.co_filename), \
      frame.f_code.co_name, \
      "{0:05}".format(frame.f_lineno), \
      "{0:04}{1:02}{2:02}_{3:02}{4:02}{5:02}.{6:06}".format(now.year,
                                                            now.month,
                                                            now.day,
                                                            now.hour,
                                                            now.minute,
                                                            now.second,
                                                            now.microsecond)

# インスタンス情報の出力
def get_instance_info(obj):

  print("--- プロパティ一覧 ---")
  for key, value in obj.__dict__.items():
    print(key, ': ', value)

  print("--- メソッド一覧 ---")
  for x in dir(obj):
    print(x, ':', type(eval("obj." + x)))

# キー入力待ち
def pause():
    print("Please 'q'")
    while True:
      done = input()
      if done == "q":
        break

def your_connection_is_not_private(driver):
  #
  # この接続ではプライバシーが保護されません
  #
  try:
    #print(driver.current_url)
    #html = driver.page_source
    #with open("/tmp/" + location()[3] + "." + str(location()[2]) + '.html', 'w', encoding='utf-8') as f:
    #  f.write(html)
    #driver.save_screenshot("/tmp/" + location()[3] + "." + str(location()[2]) + ".png")

    elem = WebDriverWait(driver, 30).until(
      EC.visibility_of_element_located((By.ID, "details-button"))
    )
    elem = driver.find_element_by_id("details-button") # 「詳細設定」ボタンをクリック
    elem.click()

    #driver.save_screenshot("/tmp/" + location()[3] + "." + str(location()[2]) + ".png")
    elem = WebDriverWait(driver, 30).until(
      EC.visibility_of_element_located((By.ID, "proceed-link"))
    )
    elem = driver.find_element_by_id("proceed-link")   # 「URLにアクセスする(安全ではありません)」リンクをクリック
    elem.click()
  except NoSuchElementException as e:
    print(e)
    pass


def login(driver, username, password):
  #
  # ログイン画面
  #
  #print(driver.current_url)
  html = driver.page_source
  with open("/tmp/" + location()[3] + "." + str(location()[2]) + '.html', 'w', encoding='utf-8') as f:
    f.write(html)
  driver.save_screenshot("/tmp/" + location()[3] + "." + str(location()[2]) + ".png")

  elem = WebDriverWait(driver, 30).until(
    EC.visibility_of_element_located((By.ID, "Frm_Username"))
  )
  elem = driver.find_element_by_id("Frm_Username")  # Username入力
  elem.send_keys(username)

  driver.save_screenshot("/tmp/" + location()[3] + "." + str(location()[2]) + ".png")
  elem = WebDriverWait(driver, 30).until(
    EC.visibility_of_element_located((By.ID, "Frm_Password"))
  )
  elem = driver.find_element_by_id("Frm_Password")  # Password入力
  elem.send_keys(password)

  driver.save_screenshot("/tmp/" + location()[3] + "." + str(location()[2]) + ".png")
  elem = WebDriverWait(driver, 30).until(
    EC.visibility_of_element_located((By.ID, "LoginId"))
  )
  driver.save_screenshot("/tmp/" + location()[3] + "." + str(location()[2]) + ".png")
  elem = driver.find_element_by_id("LoginId")       # Loginボタンクリック
  elem = elem.click()


def main():
  username = 'admin'
  password = 'defleppard'

  try:

    options = webdriver.ChromeOptions()
    options.add_argument('--ignore-certificate-errors')          # この接続ではプライバシーが保護されません画面を無効に
    options.add_argument('--allow-running-insecure-content')     # 混合コンテンツを許可
    options.add_argument('--disable-web-security')               # 
    options.add_argument('--disable-desktop-notifications')      # デスクトップ通知を無効
    options.add_argument('--disable-extensions')                 # すべての拡張機能を無効
    options.add_argument('--lang=ja')                            # 日本語
    options.add_argument('--blink-settings=imagesEnabled=false') # 画像を読み込まないで軽くする
    options.add_argument('--start-maximized')                    # 起動時にウィンドウを最大化する
    options.add_argument('--disable-extensions')                 # すべての拡張機能を無効にする。ユーザースクリプトも無効にする
    options.add_argument('--proxy-server="direct://"')           # Proxy経由ではなく直接接続する
    options.add_argument('--proxy-bypass-list=*')                # すべてのホスト名
    options.add_argument('--headless')                           # headlessモードを使用する
    options.add_argument('--disable-gpu')                        # headlessモードで暫定的に必要なフラグ(そのうち不要になる)
    
    driver = webdriver.Chrome(executable_path=CHROME, options=options)
    driver.implicitly_wait(10)                         # 要素が見つかるまで、最大10秒間待機する

    URL = "https://192.168.0.1"
    driver.get(URL)

    #your_connection_is_not_private(driver)             # この接続ではプライバシーが保護されません
    driver.save_screenshot("/tmp/" + location()[3] + "." + str(location()[2]) + ".png")
    login(driver, username, password)                  # ログイン画面
    driver.save_screenshot("/tmp/" + location()[3] + "." + str(location()[2]) + ".png")

    iframe = driver.find_element_by_id("mainFrame")
    driver.switch_to.frame(iframe)                     # フレームをスイッチ

    # ネットワークインタフェース情報
    elem = driver.find_element_by_xpath('//*[@id="smWanStatu"]')
    elem.click()                                      # ネットワークインターフェース情報をクリック
    elem = driver.find_element_by_xpath('/html/body/div[3]/div[1]/div[3]/div[1]/table/tbody/tr[5]/td[1]')
    if elem.text != "IPv4アドレス":
       raise "ERR0010" 
    elem = driver.find_element_by_xpath('/html/body/div[3]/div[1]/div[3]/div[1]/table/tbody/tr[5]/td[2]')
    print(re.sub('/[\d\.]+', '', elem.text))

  except Exception as e:
    print(traceback.format_exc())
    sys.exit(1)

  finally:
    html = driver.page_source
    with open("/tmp/" + location()[3] + "." + str(location()[2]) + '.html', 'w', encoding='utf-8') as f:
      f.write(html)
    driver.save_screenshot("/tmp/" + location()[3] + "." + str(location()[2]) + ".png")
    driver.quit()

if __name__ == '__main__':
  try:
    main()
  except Exception as e:
    print(traceback.format_exc())
  
