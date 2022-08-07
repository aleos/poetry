//
//  PoemView.swift
//  Poetry
//
//  Created by Alexander Ostrovsky on 07.08.2022.
//

import SwiftUI

struct PoemView: View {
    let title: String
    let text: String
    
    var body: some View {
        ScrollView {
            VStack {
                Text(title)
                    .foregroundColor(Color("title"))
                    .font(.custom("SavoyeLetPlain", size: 64))
                Text(text)
                    .foregroundColor(Color("text"))
                    .font(.custom("SavoyeLetPlain", size: 27))
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .background(Color("background"))

    }
}

struct PoemView_Previews: PreviewProvider {
    static var previews: some View {
        PoemView(
            title: "Море",
            text:
                """
Мамочка, мамочка, море в огне!
Капли воды завывая горят.
Мутно и страшно, как будто во сне.
Медленно время спускается в ад.

Морюшко синее, ах, не гори,
Огненной пеной не бейся в груди!
Знаю, дождусь златовласой зори,
Ей улыбнусь и пойду впереди,

Сбросив сомнения, страх позабыв,
В стельку живая от неба вина.
Раз лишь согревшись, лишь раз полюбив,
Жизнь исчерпаю до смерти, до дна.
"""
        )
    }
}
