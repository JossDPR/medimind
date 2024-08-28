class OpenAiSvc

  def comparer_photos(photo1_url, medication_name)
    question = "Peux-tu me dire si la photo montre le médicament #{medication_name}?
    Réponds avec un json: true dans la variable Reponse si les médicaments sont identiques et
    false si ils sont différents. Puis dans une variable Differences écris une phrase simple avec les
    differences si il y en a, sans rien ajouter devant le json."
    reponse = self.open_ai_comparer_photo(question, photo1_url)
    puts reponse
    return traitement_reponse(reponse)
  end

  def lecture_ordonance(photo_url)
    question = "Tu peux me donner au format json la liste des medicaments de l'ordonance en séparent le nom du medicament, la posologie, le type de posologie exemple comprimé, gélule , le moment de la prise et la durée du traitement qu'il y a sur la photo sans rien ajouter devant le json?"
    reponse = self.open_ai_question_photo(question, photo_url)
  end

  def analyser_boite(photo_url)
    question = "Tu peux me donner au format json le nom du médiacament en tant que name, le dosage en tant que dosage, le type de cachet en tant que type et la description du medicament en tant que description qu'il y a sur la photo sans rien ajouter devant le json?"
    reponse = traitement_reponse(self.open_ai_question_photo(question, photo_url))

    ##Traitement du medicament (Ajout dans la db si non trouvé)
    if reponse != ""
      medic_name = reponse['name'].upcase + " " + reponse['dosage']
      answer = Medication.find_or_create_by(name: medic_name)
    else
      answer = "Fail"
    end
    return answer
  end

  private

  def open_ai_comparer_photo(question, photo1_url)
    client = OpenAI::Client.new
    return client.chat(
      parameters: {
        model: "gpt-4o-mini",
        max_tokens: 300,
        messages: [
                    {
                      "role": "user",
                      "content": [
                        {"type": "text", "text": question},
                        {"type": "image_url", "image_url": {"url": photo1_url}},
                      ]
                    }
                  ]
      }
    )
  end

  def open_ai_question_photo(question, photo_url)
    client = OpenAI::Client.new
    return client.chat(
      parameters: {
        model: "gpt-4o-mini",
        max_tokens: 300,
        messages: [
                    {
                      "role": "user",
                      "content": [
                        {"type": "text", "text": question},
                        {"type": "image_url", "image_url": { "url": photo_url}}
                      ]
                    }
                  ]
      }
    )
  end

  def traitement_reponse(reponse)
    retour_ai = reponse["choices"][0]["message"]["content"]
    if retour_ai.include?("name") || retour_ai.include?("Reponse")
      retour_json = retour_ai.gsub(/```json|```/, '').strip
      json = JSON.parse(retour_json)
    else
      json = ""
    end
    return json
  end
end
