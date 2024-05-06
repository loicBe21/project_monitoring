defmodule PmLogin.AccountActionHistory do

  alias PmLogin.Login
  alias PmLogin.Login.AccountUserChange
  alias PmLogin.Repo


  #module de gestion des actions sur les comptes d'utilisateur




  #type d'historique
  # historique de création
  # historique de modification
  # historique d'archivage


  #type d'historique
  #archivage => "arch"
  #creation de compte => "new_acc"
  #modification de role => "change_role"
  #modification => "own_modif"








  #%{user; ussr2 ; type_action ; action_text}

  #historiue d' archivage
  def create_archivage_account_historique(user , change_type , changed_by_user) do
    change_details= "le compte de #{user.username} a été archivé par #{changed_by_user.username}"
    historique_object = %{
      user_id: user.id,
      changed_by_user_id: changed_by_user.id,
      changetype: to_string(change_type) ,
      change_details: change_details
    }
    historique_object
  end

  #genere les details de de changement par action
  #les action des admin par les compte d'autre utilisateur tels que les creation de compte , archivage de compte
  defp generate_change_details(user, changed_by_user , change_type) do
    case change_type do
      :arch ->
        "L'utilisateur #{user.username} a été archivé par #{changed_by_user.username}."
      :new_acc ->
        "Un nouvel utilisateur a été créé : #{user.username} (Créé par #{changed_by_user.username})."
      :change_role ->
        user_right =  Login.get_right!(user.right_id)
        "#{changed_by_user.username} à changé le droit de l'utilisateur #{user.username} en #{user_right.title}"
      _ ->
        "Type de changement non pris en charge "
    end
  end


#persisantance des changement dans la base de données
def record_change(user, changed_by_user , change_type) do

    change_details = generate_change_details(user, changed_by_user, change_type)
    attrs = %{
      user_id: user.id,
      change_type: to_string(change_type),
      change_details: change_details,
      changed_by_user_id: changed_by_user.id,
      changed_at: DateTime.utc_now()
    }
    record_changeset = account_change_changeset(attrs)
    Repo.insert(record_changeset)


end

defp check_mail_change(new_user , old_user ) do
    if new_user.email != old_user.email do
      "Adresse e-mail modifiée de #{old_user.email} à #{new_user.email}."
    else
      ""
    end
end

defp check_username_change( new_user , old_user) do
    if new_user.username != old_user.username do
      "Nom d'utilisateur modifié de #{old_user.username} à #{new_user.username}."
    else
      ""
    end
end

defp check_phone_number_change(new_user, old_user) do
    if new_user.phone_number != old_user.phone_number do
      "Numéro de téléphone modifié de #{old_user.phone_number} à #{new_user.phone_number}."
    else
      ""
    end
end


#création des details de changement et des mise a jour effectuer par l'utilisateur pour son propre compte
def generate_own_change_details(new_user, old_user) do

  #stocke les changement dans une liste
  [mail_change, username_change , phone_change] = [
    check_mail_change(new_user, old_user),
    check_username_change(new_user, old_user) ,
    check_phone_number_change(new_user,old_user)
  ]
  # elimine les changement vide
  changes = [mail_change, username_change , phone_change] |> Enum.reject(&(&1 == ""))
  # separe par virgule les changement
  " #{Enum.join(changes, ", ")}"


end





  def record_own_changes(new_user, old_user) do
    changes = generate_own_change_details(new_user, old_user)
    change_type = :own_modif

    user_id = new_user.id # Vous devrez adapter cela en fonction de votre application


    attrs =   %{
        user_id: user_id,
        change_type: to_string(change_type),
        change_details: changes,
        changed_at: DateTime.utc_now()
      }

    record_changeset =  own_account_change_changeset(attrs)
    Repo.insert(record_changeset)

  end


  def account_change_changeset(attrs) do
    AccountUserChange.changeset(%AccountUserChange{} , attrs)
  end

  def own_account_change_changeset(attrs) do
    AccountUserChange.own_change_changeset(%AccountUserChange{} , attrs)
  end





end
