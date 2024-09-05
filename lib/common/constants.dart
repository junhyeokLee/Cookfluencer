
const basePath = 'assets/images';


DateTime parseDateString(String dateString) {
  return DateTime.parse(dateString);
}

String translateTeamName(String teamName) {
  // 팀 이름에 따라 변환된 한국어 이름을 반환
  switch (teamName) {
    case 'Arsenal FC':
      return '아스날 FC';
    case 'Aston Villa FC':
      return '애스턴 빌라 FC';
    case 'Chelsea FC':
      return '첼시 FC';
    case 'Everton FC':
      return '에버턴 FC';
    case 'Fulham FC':
      return '풀럼 FC';
    case 'Liverpool FC':
      return '리버풀 FC';
    case 'Manchester City FC':
      return '맨체스터 시티 FC';
    case 'Manchester United FC':
      return '맨체스터 유나이티드 FC';
    case 'Newcastle United FC':
      return '뉴캐슬 유나이티드 FC';
    case 'Tottenham Hotspur FC':
      return '토트넘 홋스퍼 FC';
    case 'Wolverhampton Wanderers FC':
      return '울버햄프턴 원더러스 FC';
    case 'Leicester City FC':
      return '레스터 시티 FC';
    case 'Southampton FC':
      return '사우샘프턴 FC';
    case 'Ipswich Town FC':
      return '입스위치 타운 FC';
    case 'Nottingham Forest FC':
      return '노팅엄 포레스트 FC';
    case 'Crystal Palace FC':
      return '크리스탈 팰리스 FC';
    case 'Brighton & Hove Albion FC':
      return '브라이튼 앤 호브 알비온 FC';
    case 'Brentford FC':
      return '브렌트퍼드 FC';
    case 'West Ham United FC':
      return '웨스트햄 유나이티드 FC';
    case 'AFC Bournemouth':
      return 'AFC 본머스';
    default:
      return teamName; // 변환되지 않은 팀 이름은 그대로 반환
  }
}


String translatePlayerName(String playerName) {
  // 선수 이름에 따라 변환된 한국어 이름을 반환
  switch (playerName) {
    case "Erling Haaland":
      return "얼링 홀란드";
    case "Cole Palmer":
      return "콜 팔머";
    case "Alexander Isak":
      return "알렉산더 이삭";
    case "Dominic Solanke":
      return "도미닉 솔랑케";
    case "Phil Foden":
      return "필 포든";
    case "Ollie Watkins":
      return "올리 왓킨스";
    case "Mohamed Salah":
      return "모하메드 살라";
    case "Heung-min Son":
      return "손흥민";
    case "Bukayo Saka":
      return "부카요 사카";
    case "Jarrod Bowen":
      return "자로드 보웬";
    case "Jean-Philippe Mateta":
      return "장-필리프 마테타";
    case "Chris Wood":
      return "크리스 우드";
    case "Nicolas Jackson":
      return "니콜라스 잭슨";
    case "Kai Havertz":
      return "카이 하베르츠";
    case "Yoane Wissa":
      return "요안 위사";
    case "Hwang Heechan":
      return "황희찬";
    case "Matheus Cunha":
      return "마테우스 쿠냐";
    case "Carlton Morris":
      return "카를턴 모리스";
    case "Julián Álvarez":
      return "훌리안 알바레즈";
    case "Anthony Gordon":
      return "앤서니 고든";
    case "Darwin Núñez":
      return "다윈 누녜스";
    case "Eberechi Eze":
      return "에베레치 에제";
    case "Richarlison":
      return "리차일리송";
    case "Leandro Trossard":
      return "레안드로 트로사르";
    case "Diogo Jota":
      return "디오고 조타";
    case "Leon Bailey":
      return "레온 베일리";
    case "Bruno Fernandes":
      return "브루노 페르난데스";
    case "Elijah Adebayo":
      return "엘리야 아데바요";
    case "Michael Olise":
      return "마이클 올리세";
    case "Rasmus Højlund":
      return "라스무스 회이룬드";
    case "João Pedro":
      return "조앙 페드로";
    case "Callum Wilson":
      return "칼럼 윌슨";
    case "Bryan Mbeumo":
      return "브라이언 음베우모";
    case "Douglas Luiz":
      return "도구라스 루이즈";
    case "Rodrigo Muniz":
      return "호드리구 무니즈";
    case "Rodri":
      return "로드리";
    case "Luis Díaz":
      return "루이스 디아스";
    case "Antoine Semenyo":
      return "앙투안 세메뇨";
    case "Martin Ødegaard":
      return "마르틴 외데가르드";
    case "Raheem Sterling":
      return "라힘 스털링";
    case "Dejan Kulusevski":
      return "데얀 쿨루세프스키";
    case "Cody Gakpo":
      return "코디 각포";
    case "Callum Hudson-Odoi":
      return "칼럼 허드슨-오도이";
    case "Mohammed Kudus":
      return "모하메드 쿠두스";
    case "Odsonne Édouard":
      return "오드손 에두아르";
    case "James Ward-Prowse":
      return "제임스 월드-프라우스";
    case "Dominic Calvert-Lewin":
      return "도미닉 칼버트-루인";
    case "Bruno Guimarães":
      return "브루노 기마랑이스";
    case "Tomáš Souček":
      return "토마시 소우첵";
    case "Scott McTominay":
      return "스콧 맥토미네이";
    case "Raúl Jiménez":
      return "라우울 히메네스";
    case "Justin Kluivert":
      return "저스틴 클루이베르트";
    case "Alejandro Garnacho":
      return "알레한드로 가르나초";
    case "Taiwo Awoniyi":
      return "타이워 아워니이";
    case "Simon Adingra":
      return "사이먼 아딩라";
    case "Evan Ferguson":
      return "에반 퍼거슨";
    case "Bobby Reid":
      return "바비 리드";
    case "Moussa Diaby":
      return "무사 디아비";
    case "John McGinn":
      return "존 맥긴";
    case "Michail Antonio":
      return "미카일 안토니오";
    case "Bernardo Silva":
      return "베르나르두 실바";
    case "Sean Longstaff":
      return "숀 롱스태프";
    case "Jacob Bruun Larsen":
      return "야콥 브루운 라르센";
    case "Martinelli":
      return "마르티넬리";
    case "Oliver McBurnie":
      return "올리버 맥버니";
    case "Neal Maupay":
      return "닐 모파이";
    case "Ben Brereton":
      return "벤 브레레톤";
    case "Eddie Nketiah":
      return "에디 은케티아";
    case "Harvey Barnes":
      return "하비 바너스";
    case "Christian Romero":
      return "크리스티안 로메로";
    case "Jhon Durán":
      return "존 두란";
    case "Lyle Foster":
      return "라일 포스터";
    case "Anthony Elanga":
      return "앤서니 엘랑가";
    case "Danny Welbeck":
      return "대니 웰벡";
    case "Zeki Amdouni":
      return "제키 암두니";
    case "Mykhailo Mudryk":
      return "미하일로 무드리크";
    case "Brennan Johnson":
      return "브레넌 존슨";
    case "Morgan Gibbs-White":
      return "모건 깁스-화이트";
    case "Alex Iwobi":
      return "알렉스 이워비";
    case "Alexis Mac Allister":
      return "알렉시스 맥 알리스터";
    case "Ross Barkley":
      return "로스 바클리";
    case "Noni Madueke":
      return "노니 마두에케";
    case "Conor Gallagher":
      return "코너 갤러거";
    case "Gustavo Hamer":
      return "구스타보 하머";
    case "Lucas Paquetá":
      return "루카스 파케타";
    case "James Maddison":
      return "제임스 매디슨";
    case "João Palhinha":
      return "조앙 팔리냐";
    case "Pascal Groß":
      return "파스칼 그로스";
    case "Cameron Archer":
      return "카메론 아처";
    case "Josh Brownhill":
      return "조시 브라운힐";
    case "Gabriel Jesus":
      return "가브리엘 제수스";
    case "Ben White":
      return "벤 화이트";
    case "Willian":
      return "윌리안";
    case "Chiedozie Ogbene":
      return "치에도지 오그베네";
    case "Jordan Ayew":
      return "조던 아유";
    case "Mario Lemina":
      return "마리오 레미나";
    case "Tahith Chong":
      return "타히스 총";
    case "Pablo Sarabia":
      return "파블로 사라비아";
    case "Idrissa Gana Guèye":
      return "이드리사 가나 게예";
    case "Trent Alexander-Arnold":
      return "트렌트 알렉산더-아놀드";
    case "Harry Wilson":
      return "해리 윌슨";
    case "Marcos Senesi":
      return "마르코스 세네시";
    case "Kevin De Bruyne":
      return "케빈 더 브라위너";
    case "Ivan Toney":
      return "아이반 토니";
    case "Fabian Schär":
      return "파비안 샤르";
    case "David Fofana":
      return "다비드 포파나";
    case "Joško Gvardiol":
      return "요슈코 바르디올";
    case "Solly March":
      return "솔리 마치";
    case "Kaoru Mitoma":
      return "미토마 카오루";
    case "Pape Sarr":
      return "파페 사르";
    case "Andreas Pereira":
      return "안드레아스 페레이라";
    case "Jayden Bogle":
      return "제이든 보글";
    case "Kurt Zouma":
      return "쿠르트 주마";
    case "Mathias Jensen":
      return "마티아스 옌센";
    case "Dominik Szoboszlai":
      return "도미니크 조보슬라이";
    case "Andrew Robertson":
      return "앤드류 로버트슨";
    case "Jeremy Doku":
      return "제레미 도쿠";
    case "Miguel Almirón":
      return "미겔 알미론";
    case "Mickey van de Ven":
      return "미키 반 데 베ン";
    case "Wilson Odobert":
      return "윌슨 오도베르트";
    case "Jack Harrison":
      return "잭 해리슨";
    case "Lewis Dunk":
      return "루이스 덩크";
    case "Jacob Murphy":
      return "제이콥 머피";
    case "Ryan Christie":
      return "라이언 크리스티";
    case "Jefferson Lerma":
      return "제퍼슨 레르마";
    case "Kyle Walker":
      return "카일 워커";
    case "David Raya":
      return "다비드 라이야";
    case "Nicolas Jackson":
      return "니콜라스 잭슨";
    case "Adam Armstrong":
      return "아담 암스트롱";
    case "Che Adams":
      return "체 아담스";
    case "Stefan Bajcetic":
      return "스테판 바이체틱";
    case "Youssef Chermiti":
      return "유세프 체르미티";
    case "Antonee Robinson":
      return "안토니 로빈슨";
    case "Cameron Carter-Vickers":
      return "카메론 카터-비커스";
    case "Diogo Dalot":
      return "디오고 달롯";
    case "Alexis Sánchez":
      return "알렉시스 산체스";
    case "Héctor Bellerín":
      return "헥터 벨레린";
    case "Marc Cucurella":
      return "마르크 쿠쿠렐라";
    case "Kieran Trippier":
      return "키어런 트리피어";
    case "Sergio Reguilón":
      return "세르히오 레길론";
    case "Fábio Carvalho":
      return "파비우 카르발류";
    case "Ollie Watkins":
      return "올리 워킨스";
    case "Liam Cooper":
      return "리암 쿠퍼";
    case "Roméo Lavia":
      return "로메오 라비아";
    case "Ryan Fraser":
      return "라이언 프레이저";
    case "Patrick Bamford":
      return "패트릭 뱀포드";
    case "Kenny Tete":
      return "케니 테테";
    case "Ben White":
      return "벤 화이트";
    case "Nico Williams":
      return "니코 윌리엄스";
    case "Yéremy Pino":
      return "예레미 피노";
    case "Ismaël Koné":
      return "이스마엘 코네";
    case "Denis Zakaria":
      return "데니스 자카리아";
    case "Emiliano Buendía":
      return "에밀리아노 부엔디아";
    case "Moussa Sylla":
      return "무사 시야";
    case "Timothy Weah":
      return "티모시 웨아";
    case "Anass Zaroury":
      return "아나스 자루리";
    case "Dylan Levitt":
      return "딜란 레빗";
    case "Rico Lewis":
      return "리코 루이스";
    case "Mohammed Salisu":
      return "모하메드 살리수";
    case "Nathanaël Ngamaleu":
      return "나타나엘 응가말레우";
    case "João Cancelo":
      return "조안 캉셀루";
    case "Rúben Dias":
      return "루벤 디아스";
    case "Rodrigo De Paul":
      return "로드리고 데 폴";
    case "Nicolás Otamendi":
      return "니콜라스 오타멘디";
    case "Christian Pulisic":
      return "크리스티안 풀리시치";
    case "João Félix":
      return "조안 펠릭스";
    case "Diogo Jota":
      return "디오고 조타";
    case "Matheus Nunes":
      return "마테우스 누네스";
    case "Alfie Devine":
      return "알피 데빈";
    case "Victor Osimhen":
      return "빅토르 오시멘";
    case "Julián Álvarez":
      return "훌리안 알바레즈";
    case "Fabian Ruiz":
      return "파비안 루이즈";
    case "Cristian Romero":
      return "크리스티안 로메로";
    case "Clément Lenglet":
      return "클레망 랑글레";
    case "Nicolo Barella":
      return "니콜로 바렐라";
    case "Dani Olmo":
      return "다니 올모";
    case "Sergio Oliveira":
      return "세르히오 올리베이라";
    case "Mohammed Kudus":
      return "모하메드 쿠두스";
    case "Riyad Mahrez":
      return "리야드 마레즈";
    case "Khalid Abdulaziz":
      return "칼리드 압둘라지즈";
    case "Gabriel Martinelli":
      return "가브리엘 마르티넬리";
    case "Andreas Christensen":
      return "안드레아스 크리스텐센";
    case "Victor Lindelöf":
      return "빅토르 린델로프";
    case "Edin Džeko":
      return "에딘 제코";
    case "Dele Alli":
      return "델리 알리";
    case "Marcus Rashford":
      return "마커스 래시포드";
    case "Adama Traoré":
      return "아다마 트라오레";
    case "Romain Faivre":
      return "로맹 파이브르";
    case "Wilfried Zaha":
      return "윌프리드 자하";
    case "Hugo Lloris":
      return "우고 요리스";
    case "Nick Pope":
      return "닉 포프";
    case "Ederson":
      return "에데르손";
    case "Aaron Ramsdale":
      return "아론 램스데일";
    case "Illan Meslier":
      return "일란 메슬리에";
    case "Sam Johnstone":
      return "샘 존스톤";
    case "Kasper Schmeichel":
      return "카스퍼 슈마이켈";
    case "Alphonse Areola":
      return "알폰스 아레올라";
    case "Pau Torres":
      return "파우 토레스";
    case "Victor Lindelöf":
      return "빅토르 린델로프";
    case "Nathan Aké":
      return "네이선 아케";
    case "James Tarkowski":
      return "제임스 타르코프스키";
    case "Sergio Reguilón":
      return "세르히오 레길론";
    case "Marcos Acuña":
      return "마르코스 아쿠냐";
    case "David Alaba":
      return "다비드 알라바";
    case "Thomas Müller":
      return "토마스 뮐러";
    case "Joshua Kimmich":
      return "여수아 킴미히";
    case "Leroy Sané":
      return "레로이 사네";
    case "Nico Schlotterbeck":
      return "니코 슐로터벡";
    case "Matthijs de Ligt":
      return "마타이스 더 리흇";
    case "Alphonso Davies":
      return "알폰소 데이비스";
    case "Frenkie de Jong":
      return "프렌키 더 용";
    case "Denzel Dumfries":
      return "덴젤 둠프리스";
    case "João Cancelo":
      return "조안 캉셀루";
    case "Luis Suárez":
      return "루이스 수아레즈";
    case "Mauro Icardi":
      return "마우로 이카르디";
    case "Neymar":
      return "네이마르";
    case "Angel Di Maria":
      return "앙헬 디 마리아";
    case "Kylian Mbappé":
      return "킬리안 음바페";
    case "Ousmane Dembélé":
      return "우스망 뎀벨레";
    case "Gabriel Jesus":
      return "가브리엘 제수스";
    case "Thiago Silva":
      return "티아고 실바";
    case "Vinícius Júnior":
      return "비니시우스 주니어";
    case "Edin Džeko":
      return "에딘 제코";
    case "Luis Díaz":
      return "루이스 디아스";
    case "Mohammed Salah":
      return "모하메드 살라";
    case "Sadio Mané":
      return "사디오 마네";
    case "Nicolas Pépé":
      return "니콜라스 페페";
    case "Raúl Jiménez":
      return "라우울 히메네스";
    case "César Azpilicueta":
      return "세자르 아스필리쿠에타";
    case "Luka Modrić":
      return "루카 모드리치";
    case "Toni Kroos":
      return "토니 크로스";
    case "Luka Jovic":
      return "루카 요비치";
    case "Isco":
      return "이스코";
    case "Marco Asensio":
      return "마르코 아센시오";
    case "Federico Valverde":
      return "페데리코 발베르데";
    case "Dani Carvajal":
      return "다니 카르바할";
    case "Álvaro Morata":
      return "알바로 모라타";
    case "Sergio Ramos":
      return "세르히오 라모스";
    case "Gerard Piqué":
      return "제라르 피케";
    case "Cesc Fàbregas":
      return "세스크 파브레가스";
    case "Iker Casillas":
      return "이케르 카시야스";
    case "Rafael Nadal":
      return "라파엘 나달";
    case "Fernando Alonso":
      return "페르난도 알론소";
    case "Xavi Hernández":
      return "샤비 에르난데스";
    case "Andrés Iniesta":
      return "안드레스 이니에스타";
    case "David Villa":
      return "다비드 비야";
    case "Gerard Moreno":
      return "헤라르 모레노";
    case "César Azpilicueta":
      return "세자르 아스필리쿠에타";
    case "Eric García":
      return "에릭 가르시아";
    case "Pedri":
      return "페드리";
    case "Gavi":
      return "가비";
    case "Ansu Fati":
      return "안수 파티";
    case "Ferran Torres":
      return "페란 토레스";
    case "Pablo Sarabia":
      return "파블로 사라비아";
    case "Raúl García":
      return "라우울 가르시아";
    case "Mikel Oyarzabal":
      return "미켈 오야르자발";
    case "Asier Illarramendi":
      return "아시르 일라라멘디";
    case "Iñaki Williams":
      return "이냐키 윌리엄스";
    case "Gerard Piqué":
      return "제라르 피케";
    case "Sergio Busquets":
      return "세르히오 부스케츠";
    case "Carlos Soler":
      return "카를로스 솔레르";
    case "Marcos Llorente":
      return "마르코스 요렌테";
    case "Saúl Ñíguez":
      return "사울 니게스";
    case "Álvaro Morata":
      return "알바로 모라타";
    case "Nico González":
      return "니코 곤살레스";
    case "Marcos Alonso":
      return "마르코스 알론소";
    case "Sergio Canales":
      return "세르히오 카날레스";
    case "Pau Torres":
      return "파우 토레스";
    case "Gerard Moreno":
      return "헤라르 모레노";
    case "Adama Traoré":
      return "아다마 트라오레";
    case "Koke":
      return "코케";
    case "Cesar Azpilicueta":
      return "세자르 아스필리쿠에타";
    case "Fabián Ruiz":
      return "파비안 루이즈";
    case "Dani Olmo":
      return "다니 올모";
    case "Sergio Ramos":
      return "세르히오 라모스";
    case "David De Gea":
      return "다비드 데 헤아";
    case "Unai Simón":
      return "우나이 시몬";
    case "Yeray Álvarez":
      return "예라이 알바레즈";
    case "Julen Lopetegui":
      return "줄렌 로페테기";
    case "Luis Enrique":
      return "루이스 엔리케";
    case "Carlos Alcaraz":
      return "카를로스 알카라스";
    case "Rafael Nadal":
      return "라파엘 나달";
    case "Fernando Alonso":
      return "페르난도 알론소";
    case "Miguel Indurain":
      return "미겔 인두라인";
    case "Pau Gasol":
      return "파우 가솔";
    case "Ricky Rubio":
      return "리키 루비오";
    case "Gerard Piqué":
      return "제라르 피케";
    case "Xavi Hernández":
      return "샤비 에르난데스";
    case "Andrés Iniesta":
      return "안드레스 이니에스타";
    case "Sergio Busquets":
      return "세르히오 부스케츠";
    case "Diego Simeone":
      return "디에고 시메오네";
    case "Zinedine Zidane":
      return "지네딘 지단";
    case "Pep Guardiola":
      return "펩 과르디올라";
    case "Carlo Ancelotti":
      return "카를로 안첼로티";
    case "Antonio Conte":
      return "안토니오 콘테";
    case "Jürgen Klopp":
      return "위르겐 클롭";
    case "Thomas Tuchel":
      return "토마스 투헬";
    case "Mikel Arteta":
      return "미켈 아르테타";
    case "Roberto Mancini":
      return "로베르토 만치니";
    case "Gian Piero Gasperini":
      return "지안 피에로 가스페리니";
    case "Unai Emery":
      return "우나이 에메리";
    case "Eusebio Sacristán":
      return "에우세비오 사크리스탄";
    case "Luis Enrique":
      return "루이스 엔리케";
    case "Rafael Benítez":
      return "라파엘 베니테즈";
    case "Fabio Capello":
      return "파비오 카펠로";
    case "Vicente del Bosque":
      return "빅센트 델 보스케";
    case "Carlos Bianchi":
      return "카를로스 비앙치";
    case "Diego Maradona":
      return "디에고 마라도나";
    case "Lionel Messi":
      return "리오넬 메시";
    case "Cristiano Ronaldo":
      return "크리스티아누 호날두";
    case "Ronaldinho":
      return "호나우지뉴";
    case "Zinedine Zidane":
      return "지네딘 지단";
    case "Ronaldo Nazário":
      return "호나우두 나자리우";
    case "Pele":
      return "펠레";
    case "Johan Cruyff":
      return "요한 크루이프";
    case "Alfredo Di Stéfano":
      return "알프레도 디 스테파노";
    case "Garrincha":
      return "가린샤";
    case "Michel Platini":
      return "미셸 플라티니";
    case "Franz Beckenbauer":
      return "프란츠 베켄바워";
    case "George Best":
      return "조지 베스트";
    case "Bobby Charlton":
      return "바비 찰턴";
    case "Gerd Müller":
      return "게르트 뮐러";
    case "Marco van Basten":
      return "마르코 반 바스텐";
    case "Ronald Koeman":
      return "로날드 코만";
    case "Andrés Iniesta":
      return "안드레스 이니에스타";
    case "Zinedine Zidane":
      return "지네딘 지단";
    case "Raúl González":
      return "라우울 곤살레스";
    case "Samuel Eto'o":
      return "사무엘 에토오";
    case "Ronaldo":
      return "호나우두";
    case "David Beckham":
      return "데이비드 베컴";
    case "Thierry Henry":
      return "티에리 앙리";
    case "Ronaldinho":
      return "호나우지뉴";
    case "Lothar Matthäus":
      return "로타르 마테우스";
    case "Roberto Baggio":
      return "로베르토 바조";
    case "Diego Maradona":
      return "디에고 마라도나";
    case "Lionel Messi":
      return "리오넬 메시";
    case "Cristiano Ronaldo":
      return "크리스티아누 호날두";
    case "Pelé":
      return "펠레";
  // 이 패턴으로 모든 선수 이름을 추가하세요.
  // ...
    default:
      return playerName; // 한국어 번역이 없을 경우 원래 이름 반환
  }
}

String translatePosition(String position) {
  // 포지션 이름에 따라 변환된 한국어 이름을 반환
  switch (position) {
    case 'Goalkeeper':
      return '골키퍼';
    case 'Centre-Back':
      return '센터백';
    case 'Left-Back':
      return '왼쪽 수비수';
    case 'Right-Back':
      return '오른쪽 수비수';
    case 'Defensive Midfield':
      return '수비형 미드필더';
    case 'Central Midfield':
      return '중앙 미드필더';
    case 'Attacking Midfield':
      return '공격형 미드필더';
    case 'Midfield':
      return '미드필더';
    case 'Left Winger':
      return '왼쪽 윙어';
    case 'Right Winger':
      return '오른쪽 윙어';
    case 'Centre-Forward':
      return '센터 포워드';
    case 'Offence':
      return '공격수';
    case '':
      return'empty';
    default:
      return position; // 변환되지 않은 포지션은 그대로 반환
  }
}