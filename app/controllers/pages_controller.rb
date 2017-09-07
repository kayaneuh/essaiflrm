class PagesController < ApplicationController
  def home
  end
  
  def search
    # vérifier s'il y a des éléments qui ont été recherché et s'ils contiennt quelque chose
    if params[:search].present? && params[:search].strip != ""
      session[:froomkanet_search] = params[:search]
    
  end
    
    arrResult = Array.new
    
    # si on a une session non vide
    if session[:froomkanet_search] && session[:froom_search] != ""
      # active true : l'annonce doit être active pour pouvoir être recherché
      # soit on affiche les annonces active et proches (et qui ont forcément une adresse)
      @rooms_address = Room.where(active: true).near(session[:froomkanet_search], 5, order:'distance')
    else
      # soit toutes les annonces si on a pas d'adresse
      @rooms_address = Room.where(active: true).all
    end
      # le "q" est une variable de ransack qui permet de chercher les infos demandées dans le formulaire de recherche
      @search = @rooms_address.ransack(params[:q])
      #dans la variable rooms, on enregistre tous les résultats
      @rooms = @search.result
      
      # to_a : conversion en tableau
      @arrRooms = @rooms.to_a
      
      # vérifier dates demandées dans la recherche sont disponibles
      
      if (params[:start_date] && params[:end_date] && !params[:start_date].empty? & !params[:end_date].empty?)
        
         start_date = Date.parse(params[:start_date])
         end_date = Date.parse(params[:end_date])
         
      # boucle sur l'ens de la table room pour chercher dans toutes les annonces et vérifier que les dates sont dispos
         @rooms.each do |room|
      # not_available : variable pour vérifier la disponibilité d'une annonce
            not_available = room.reservations.where("(? <= start_date AND start_date <= ?) OR 
            (? <= end_date AND end_date <= ?) OR (start_date < ? AND ? < end_date)", start_date, end_date,
            start_date, end_date, start_date, end_date).limit(1)
      # si la length de not_available est supérieur à 0, on supprime l'annonce de la liste des annonces dispos
      #ce qui permet de retourner les annonces dispos
            if not_available.length > 0
               @arrRooms.delete(room)
            end
         end
    end
end
end
