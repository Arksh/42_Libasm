# ================================ COLORS ==================================== #

_BLACK			= \033[0;30m
_RED			= \033[0;31m
_GREEN			= \033[0;32m
_YELLOW			= \033[0;33m
_BLUE			= \033[0;34m
_PURPLE			= \033[0;35m
_CYAN			= \033[0;36m
_WHITE			= \033[0;37m
_BOLD			= \033[1m
_THIN			= \033[2m
_END			= \033[0m

# ================================= NAMES ==================================== #

NAME			= libasm.a
NAME_BONUS		= libasm_bonus.a

# =============================== COMPILER =================================== #

ASM				= nasm
CFLAGS			= -f elf64
CC				= gcc

# =============================== INCLUDES =================================== #

INCLUDES		= include

# ============================== DIRECTORIES ================================= #

SRC_DIR			= src/
OBJ_DIR			= obj/

# ================================ SOURCES =================================== #

SRC				= ft_strlen \
				  ft_strcpy \
				  ft_strcmp \
				  ft_write \
				  ft_read \
				  ft_strdup

BONUS			= ft_atoi_base_bonus \
				  #ft_list_push_front_bonus \
				  #ft_list_size_bonus \
				  #ft_list_sort_bonus \
				  #ft_list_remove_if_bonus

# ================================ OBJECTS =================================== #

OBJ				= $(addprefix $(OBJ_DIR), $(addsuffix .o, $(SRC)))
OBJ_BONUS		= $(addprefix $(OBJ_DIR), $(addsuffix .o, $(SRC))) \
				  $(addprefix $(OBJ_DIR), $(addsuffix .o, $(BONUS)))

# ================================= RULES ==================================== #

.PHONY: all bonus clean fclean re test

all: $(NAME)

bonus: $(NAME_BONUS)

# ============================== COMPILATION ================================= #

$(OBJ_DIR)%.o: $(SRC_DIR)%.s
	@mkdir -p $(@D)
	@printf "\e[?25l"
	@printf "$(_YELLOW)Compiling $(NAME) binary files...$(_END)\n\n"
	@printf "\033[A\33[2K\r$(_CYAN)Binary: $@$(_END)\n"
	@$(ASM) $(CFLAGS) $< -o $@

$(NAME): $(OBJ)
	@ar rc $(NAME) $(OBJ)
	@printf "$(_GREEN)✓ $(NAME) created successfully!$(_END)\n"
	@printf "\e[?25h"

$(NAME_BONUS): $(OBJ_BONUS)
	@ar rc $(NAME_BONUS) $(OBJ_BONUS)
	@printf "$(_GREEN)✓ $(NAME_BONUS) created successfully!$(_END)\n"
	@printf "\e[?25h"

# =============================== CLEANING =================================== #

clean:
	@printf "$(_YELLOW)Cleaning object files...$(_END)\n"
	@$(RM) -rf $(OBJ_DIR)
	@printf "$(_GREEN)✓ Object files deleted.$(_END)\n"

fclean: clean
	@printf "$(_YELLOW)Removing $(NAME)...$(_END)\n"
	@$(RM) -f $(NAME) $(NAME_BONUS)
	@printf "$(_GREEN)✓ $(NAME) deleted.$(_END)\n"

re: fclean all
	@printf "\e[?25h"

# ================================ TESTING =================================== #

test: all
	@$(CC) -o main.out test/main.c -L. -lasm -I$(INCLUDES)
	@printf "$(_GREEN)✓ Test program created.$(_END)\n"

test_bonus: bonus
	@$(CC) -o main_bonus.out test/main_bonus.c -L. -lasm_bonus -I$(INCLUDES)
	@printf "$(_GREEN)✓ Test program (with bonus) created.$(_END)\n"