defmodule OfferHunters.Users.Get do
  @moduledoc """
    Get Users data
  """
  alias OfferHunters.{Error, Repo, User}

  @doc """
  Recive the email and seacrh this into the database.

  ## Examples
  iex> OfferHunters.Users.Get.get_by_email("jp@banana.com")
        {:ok,
          %OfferHunters.User{
            __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
            email: "jp@banana.com",
            id: "a66d859c-b3e4-4482-8460-615d97f91eab",
            inserted_at: ~N[2021-10-26 13:39:48],
            name: "Jp",
            offers: #Ecto.Association.NotLoaded<association :offers is not loaded>,
            profile_picture: "src/banana",
            updated_at: ~N[2021-10-26 13:39:48]
        }}

  iex> OfferHunters.Users.Create.call(%{email: "jp@banana.com"})
        {:error, %OfferHunters.Error{result: "Email does not sexist", status: :bad_request}}

  iex> OfferHunters.Users.Create.call(%{})
      {:error,
        %OfferHunters.Error{
          result: #Ecto.Changeset<
          action: :insert,
          changes: %{},
          errors: [
            email: {"can't be blank", [validation: :required]},
            profile_picture: {"can't be blank", [validation: :required]},
            name: {"can't be blank", [validation: :required]}
          ],
          data: #OfferHunters.User<>,
          valid?: false
        >,
        status: :bad_request
      }}
  """
  @spec get_by_email(String.t()) ::
          {:ok, %User{}}
          | {:error, %OfferHunters.Error{result: String.t(), status: :bad_request}}

  def get_by_email(email) do
    case Repo.preload(Repo.get_by(User, email: email), :offers) do
      %User{} = user -> {:ok, user}
      nil -> {:error, Error.build(:bad_request, "Email does not exist")}
    end
  end

  @doc """
  When called, return a list of all users

  ## Examples
  iex> OfferHunters.Users.Get.get_all_users()
  """
  @spec get_all_users() ::
          [
            %OfferHunters.User{
              email: String.t(),
              id: String.t(),
              name: String.t(),
              profile_picture: String.t(),
              offers: %{
                description: String.t(),
                promotion_link: String.t(),
                image: bitstring(),
                expiration_date: Date.t(),
                value: Decimal.t()
              }
            }
          ]

  def get_all_users, do: Repo.preload(Repo.all(User), :offers)
end
