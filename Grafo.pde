// Definição da classe Grafo
public class Grafo {
  int numVertices;
  int[][] matrizAdj;
  PVector[] posicoes; // Posições das partículas (nós do grafo)
  PVector[] velocidades; // Velocidades das partículas
  float raio = 10; // Raio dos nós
  float k = 0.001; // Constante da mola para a atração
  float c = 3000; // Constante de repulsão
  int[] coresSetted = new int[numVertices];
  
  // Construtor da classe Grafo
  Grafo(int numVertices) {
    this.numVertices = numVertices;
    matrizAdj = new int[numVertices][numVertices];
    posicoes = new PVector[numVertices];
    velocidades = new PVector[numVertices];
    inicializarPosicoes();
    coresSetted = colorirGrafo();
  }
  
  Grafo(int[][] adj) {
    this.numVertices = adj.length;
    matrizAdj = adj;
    posicoes = new PVector[numVertices];
    velocidades = new PVector[numVertices];
    inicializarPosicoes();
    coresSetted = colorirGrafo();
  }

  // Adiciona uma aresta entre dois vértices
  void adicionarAresta(int i, int j) {
    matrizAdj[i][j] = 1;
    matrizAdj[j][i] = 1; // Para grafos não direcionados
  }
  
  // Adiciona uma aresta entre dois vértices
  void adicionarAresta(int i, int j, int peso) {
    matrizAdj[i][j] = peso;
    matrizAdj[j][i] = peso; // Para grafos não direcionados
  }

  // Inicializa as posições das partículas em um círculo
  void inicializarPosicoes() {
    float angulo = TWO_PI / (numVertices - 1);
    float raioCirculo = min(width, height) / 3;
    for (int i = 1; i < numVertices; i++) {
      float x = width / 2 + raioCirculo * cos((i - 1) * angulo);
      float y = height / 2 + raioCirculo * sin((i - 1) * angulo);
      posicoes[i] = new PVector(x, y);
      velocidades[i] = new PVector(0, 0);
    }
    // Posição fixa do vértice 0
    posicoes[0] = new PVector(width / 2, height / 2);
    velocidades[0] = new PVector(0, 0);
  }

  // Atualiza as posições das partículas
  void atualizar() {
    for (int i = 1; i < numVertices; i++) {
      PVector forca = new PVector(0, 0);
      
      // Força de repulsão
      for (int j = 0; j < numVertices; j++) {
        if (i != j) {
          PVector direcao = PVector.sub(posicoes[i], posicoes[j]);
          float distancia = direcao.mag();
          if (distancia > 0) {
            direcao.normalize();
            float forcaRepulsao = c / (distancia * distancia);
            direcao.mult(forcaRepulsao);
            forca.add(direcao);
          }
        }
      }

      // Força de atração
      for (int j = 0; j < numVertices; j++) {
        if (matrizAdj[i][j] > 0) {
          PVector direcao = PVector.sub(posicoes[j], posicoes[i]);
          float distancia = direcao.mag();
          direcao.normalize();
          float forcaAtracao = k * (distancia - raio);
          direcao.mult(forcaAtracao);
          forca.add(direcao);
        }
      }

      velocidades[i].add(forca);
      posicoes[i].add(velocidades[i]);

      // Reduz a velocidade para estabilizar a simulação
      velocidades[i].mult(0.5);

      // Mantém as partículas dentro da tela
      if (posicoes[i].x < 0 || posicoes[i].x > width) velocidades[i].x *= -1; 
      if (posicoes[i].y < 0 || posicoes[i].y > height)velocidades[i].y *= -1;
     
    }
  }

  // Desenha o grafo
  void desenhar() {
    textAlign(CENTER);
    // Desenha as arestas
    stroke(0);
    strokeWeight(1);
    for (int i = 0; i < numVertices; i++) {
      for (int j = i + 1; j < numVertices; j++) {
        strokeWeight(matrizAdj[i][j]);
        if (matrizAdj[i][j] > 0) line(posicoes[i].x, posicoes[i].y, posicoes[j].x, posicoes[j].y);
      }
    }

    // Desenha os nós
    fill(255);
    stroke(0);
    strokeWeight(1);
    int[] coresPropDit = {#ff0000,#00f00,#0000ff,#ffff00,#ff00ff,#00ffff};
    for (int i = 0; i < numVertices; i++) {
      fill(coresPropDit[coresSetted[i]]);
      ellipse(posicoes[i].x, posicoes[i].y, raio * 2, raio * 2);
      fill(0);
      text(str(i), posicoes[i].x, posicoes[i].y+4);
    }
  }
  
  void dijkstra(int origem, int destino){
    int[] dist = new int[numVertices];
    int[] anterior = new int[numVertices];
    for(int v = 0; v < numVertices; v++){
      dist[v] = 1000000;
      anterior[v] = -1;
    }
    
    dist[origem] = 0;
    int[] Q = new int[numVertices];
    for(int k = 0; k < numVertices; k++){
      int u = -1;
      int udist = 10000000;
      for(int v = 0; v < numVertices; v++){
        if(Q[v] == 0 && dist[v] < udist){
          u = v;
          udist = dist[v];
        }
      }
        
      Q[u] = 1;
        
      for(int v = 0; v < numVertices; v++){
          if(u == v || matrizAdj[u][v] == 0) continue;
           
            int alt = udist + matrizAdj[u][v];
            
            if(alt < dist[v]){
              dist[v] = alt;
              anterior[v] = u;
            }
        }  
    }
    
    return;
  }

  int[] colorirGrafo(){
    int[][] g = matrizAdj;
    int n = numVertices;
    int[] cores = new int[n];
    boolean[] coresDisponiveis = new boolean[n];
    for (int i=0;i<n;i++){
        coresDisponiveis[i] = true;
    }
    for (int v=0;v<n;v++){
        for (int u =0;u<n;u++){
            if (g[v][u]==1){                                                                                                                                                                    
                if (cores[u]!=0){
                    coresDisponiveis[cores[u]] = false;
                }
            }
        }
        for (int cor=0;cor<n;cor++){
            if (coresDisponiveis[cor] == true){
                cores[v] = cor;
                break;
            }
        }
        for (int i=0;i<n;i++){
            coresDisponiveis[i] = true;//
        }
    }
    return cores;
  }
}
