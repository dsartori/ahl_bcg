class AnimalGame:
"""A python implementation of ANIMAL.BAS """
    def __init__(self):
        self.tree = []
        self.load_initial_data()

    def load_initial_data(self):
        self.tree = ['4','|QDOES IT SWIM|Y2|N3|','|AFISH','|ABIRD']

    def ask_questions(self, idx=1):
        while True:
            node = self.tree[idx]
            if node.startswith('|A'):
                print(f"IS IT A {node[2:]}?")
                answer = input("(Y/N): ").strip().upper()
                if answer == 'Y':
                    print("CORRECT!")
                else:
                    learned_animal = input("WHAT ANIMAL WERE YOU THINKING OF? ").strip().upper()
                    new_question = input(f"PLEASE PROVIDE A QUESTION TO DISTINGUISH A {learned_animal} FROM A {node[2:]}: ").strip().upper()
                    answer = input(f"FOR A {learned_animal}, WHAT IS THE ANSWER TO YOUR QUESTION? (Y/N): ").strip().upper()
                    self.learn(learned_animal, new_question, answer, idx)
                return
            elif node.startswith('|Q'):
                question = node[2:].split('|')[0]
                print(question)
                answer = input("(Y/N): ").strip().upper()
                find_str = "|" + answer
                idx = int(node[node.index(find_str)+ 2:node.index('|', node.index(find_str)+2)])
            else:
                print("INVALID NODE.")
                return

    def learn(self, animal, question, answer, idx):
        existing_animal = self.tree[idx][2:]
        new_index = int(self.tree[0])
        self.tree[0] = str(new_index + 2)
        if new_index >= len(self.tree):
            self.tree.extend([''] * (new_index - len(self.tree) + 3))
        self.tree[new_index] = self.tree[idx]
        if answer == 'Y':
            self.tree[idx] = f'|Q{question}|Y{idx+1}|N{idx+2}|'
            self.tree[new_index+1] = f'|A{animal}'
            self.tree[new_index+2] = f'|A{existing_animal}'
        else:
            self.tree[idx] = f'|Q{question}|Y{idx+2}|N{idx+1}|'
            self.tree[new_index+1] = f'|A{existing_animal}'
            self.tree[new_index+2] = f'|A{animal}'
            
    def list_animals(self):
        animals = [node[2:] for node in self.tree if node.startswith('|A')]
        print("ANIMALS I ALREADY KNOW:")
        for animal in animals:
            print(f"- {animal}")

    def first_question(self):
        print("ARE YOU THINKING OF AN ANIMAL?")
        answer = input("(Y/N or LIST): ")
        if answer.strip().upper() == 'LIST':
            self.list_animals()
            self.first_question()
        elif answer.strip().upper() == 'Y':
            self.ask_questions()
        else:
            print("GOODBYE!")

    def play_game(self):
        self.first_question()

if __name__ == "__main__":
    game = AnimalGame()
    game.play_game()