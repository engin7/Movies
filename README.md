# Movies
 
## About

 Movies is is an iOS app which connects to The Movie Database (TMDb) API and show users list of movies. User can star movies and check details. 
 
 ## Developement

  MVC design pattern is used in this project. DataSource of CollectionView is seperated from the ViewController to make VC more compact.
 Singletons used for Network Layer and DataSource. DataSource made loosely coupled as it has no relationships with Network Layer directly. 
 an Indicator added to the Footer of Collection View to animate during loading next pages. This indicator stops if user is searching or gets to the end page.
 <br/>When loading more pages at then end of row a delegate used not to include Network layer and make project more modular.  
  Condition of cell size checked and DataSource change images accordingly for better scaling (poster/backdrop)
<br/>UserDefaults used to persist favorites conditon of the movie. Movie id written in a dictionary with Bool value. 
 
 ## Requirements

  Minimum IOS deployment target 14.0 and support both Iphone and Ipad.  
  XCode 12.0.1 Swift 5.3 used
 
 ## License

  This app is open source. If you find a bug please open an issue. Feel free to contribute.
  
 ## App screenshots

 <img width="1000" alt="iphone" src="https://user-images.githubusercontent.com/32449276/97598285-d4b2f500-1a17-11eb-8fb3-5e023c2681e6.png"> 

 <img width="1000" alt="ipad" src="https://user-images.githubusercontent.com/32449276/97599945-99b1c100-1a19-11eb-9146-2e2be80d56f5.png">
