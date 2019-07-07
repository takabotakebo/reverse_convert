//元画像
PImage BaseImage;


//変換コードの情報を格納する配列
ArrayList<ArrayList<Integer>> ConversionCode = new ArrayList<ArrayList<Integer>>();

//各種変数の宣言
int[] random ;       //ランダムな整数の配列の宣言
boolean drawing;     //描画中かどうかの判定
int drawCount = 0;   //描画数
int imagewidth;      //画像幅
int imageheight;     //画像高さ
int pixelAmount;     //ピクセル総数
boolean standby;     //待機中かどうか




void setup() {
  //画像の読み込み
  BaseImage = loadImage("mosaic.png"); 
  BaseImage.loadPixels(); //画像のピクセルを一次元配列として取得
  
  
  // 画面サイズの指定
  imagewidth = BaseImage.width;
  imageheight = BaseImage.height;
  surface.setResizable(true);
  surface.setSize(imagewidth,imageheight);   //画像の大きさに
  
  
  //変換コードのCSVの読み込み
  String ConversionCode_csv[] = loadStrings("ConversionCode.csv");
  
  for(int i =0; i < ConversionCode_csv.length; i++){
    String data[] = split(ConversionCode_csv[i],',');
    ArrayList<Integer> dataList = new ArrayList<Integer>();
    dataList.add(int(data[1]));
    dataList.add(int(data[0]));
    ConversionCode.add(dataList);
  }
  
  //画像のピクセル数の取得
  pixelAmount = ConversionCode.size();
  print(pixelAmount);
  
  //初期設定
  drawing = false;
  drawCount = 0;
  standby = true;
  
  //画像の総ピクセル数と対応したランダムな整数の配列の生成
  random = get_no_dup_numbers(pixelAmount);  

  
}

void draw(){
 
  
  //スタンバイモードだと画像を表示
  if(standby == true){
    if(drawing == false){
      //画像を表示
      image(BaseImage, 0, 0); //画像を表示
        print("SET Image");
      standby = false;
    }
  }

  
  
  //lキーが押された時
  if((keyPressed == true) && (key == 'l')){
    //描画をON
    drawing = true;
    
    //スタンバイモードじゃなくする
    standby = false;
    
    //一度画面をリフレッシュ
    fill(255);
    rect(0,0,width,height);
  };
  
  if(drawing == true){
    for(int loop = 0; loop < 10000; loop++){
      
      //重複のないランダム番号(drawCountをスタートとしてloop回数ずつ加算)
      int randomNum = random[drawCount+loop];
      
      int basepixelNum = ConversionCode.get(randomNum).get(0);
      int landscapepixelNum = ConversionCode.get(randomNum).get(1);
      
      int[] position = convert_Num2Position(landscapepixelNum);
      
      //positionの位置に点を描画
      fill(BaseImage.pixels[basepixelNum]);
      stroke(BaseImage.pixels[basepixelNum]);
      point(position[0],position[1]);
      
      //ループが元画像(myPhoto)の全ピクセルに達したら描画を停止し、カウントをリセット
      if( drawCount+loop == pixelAmount -1){
        drawing = false;
        drawCount = 0;
        
        println("Made Landscape");
        //シャッフル画像の保存
        save("data/me.png");
        break;
      }  
    }
    
  drawCount = drawCount + 10000;
  
  }
  
  
  
}




//0~(引数に指定された数-1)までを全て使った重複しない整数のランダム配列の生成
int[] get_no_dup_numbers(int number){   
  IntList nums = new IntList(number);
  for (int i = 0; i < number; i++){
    nums.append(i);
  };
  nums.shuffle();
  int[] result = nums.array();
  return result;
}



//配列の番号からxy座標を計算する関数
int[] convert_Num2Position(int num){
  int x = num % imagewidth ;
  int y = (num - num % imagewidth) /  imagewidth;
  int[] position = {x,y}; 
  return position;
}



//終了時の動作
void dispose() {
  println("exit.");
}
