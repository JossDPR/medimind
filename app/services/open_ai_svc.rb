class OpenAiSvc

  def comparer_photos(photo1_url, photo2_url)
    question = "Tu peux me dire au format json si ce sont les mêmes noms de médicaments, les mêmes posologies, je veux True dans la variable Reponse si c'est elles sont identiques et False le cas contraire puis dans une variable Differences une phrase simple avec les differences si il y en a, sans rien ajouter devant le json?"
    reponse = self.open_ai_comparer_photo(question, photo1_url, photo2_url)

  end

  def lecture_ordonance(photo_url)
    question = "Tu peux me donner au format json la liste des medicaments de l'ordonance en séparent le nom du medicament, la posologie, le type de posologie exemple comprimé, gélule , le moment de la prise et la durée du traitement qu'il y a sur la photo sans rien ajouter devant le json?"
    reponse = self.open_ai_question_photo(question, photo_url)
  end

  def analyser_boite(photo_url)
    question = "Tu peux me donner au format json le nom du médiacament en tant que name, le dosage en tant que dosage, le type de cachet en tant que type et la description du medicament en tant que description qu'il y a sur la photo sans rien ajouter devant le json?"
    reponse = traitement_reponse(self.open_ai_question_photo(question, photo_url))

    ##Traitement du medicament (Ajout dans la db si non trouvé)
    medic_name = reponse['name'].upcase + " " + reponse['dosage']
    check_medic = Medication.where(name: medic_name)
    if (check_medic.count == 0)
      medic = Medication.new
      medic.name =medic_name
      medic.description = reponse['description']
      medic.save!
      return medic
    else
      return check_medic
    end
  end

  private

  def open_ai_comparer_photo(question, photo1_url, photo2_url)
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
                        {"type": "image_url", "image_url": {"url": photo2_url}}
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
    retour_json = retour_ai.gsub(/```json|```/, '').strip
    return JSON.parse(retour_json)
  end

end
