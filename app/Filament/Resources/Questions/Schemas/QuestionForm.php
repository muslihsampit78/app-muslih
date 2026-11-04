<?php

namespace App\Filament\Resources\Questions\Schemas;

use App\Enums\AnswerStatus;
use App\Enums\QuestionStatus;
use Filament\Forms\Components\DateTimePicker;
use Filament\Forms\Components\Hidden;
use Filament\Forms\Components\Repeater;
use Filament\Forms\Components\RichEditor;
use Filament\Forms\Components\Section;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Schema;

class QuestionForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make(__('Inquirer & Question Information'))
                    ->components([
                        TextInput::make('name')
                            ->label(__('Inquirer Name'))
                            ->required(),
                        TextInput::make('email')
                            ->label(__('Email Address'))
                            ->email()
                            ->required(),
                        TextInput::make('phone')
                            ->label(__('Phone / WhatsApp Number')),
                        Select::make('topic_id')
                            ->label(__('Topic'))
                            ->relationship('topic', 'name')
                            ->searchable()
                            ->preload(),
                        TextInput::make('subject')
                            ->label(__('Question Subject'))
                            ->required()
                            ->columnSpanFull(),
                        Textarea::make('body')
                            ->label(__('Full Question Content'))
                            ->rows(4)
                            ->required()
                            ->columnSpanFull(),
                        Select::make('status')
                            ->label(__('Question Status'))
                            ->options(collect(QuestionStatus::cases())->mapWithKeys(fn (QuestionStatus $s) => [
                                $s->value => $s->label(),
                            ]))
                            ->default(QuestionStatus::Pending->value)
                            ->required(),
                    ])
                    ->columns(2),

                Section::make(__('Officer Responses / Answers'))
                    ->components([
                        Repeater::make('answers')
                            ->label(__('Response History'))
                            ->relationship('answers')
                            ->schema([
                                RichEditor::make('body')
                                    ->label(__('Officer Answer Content'))
                                    ->required()
                                    ->columnSpanFull(),
                                Select::make('status')
                                    ->label(__('Answer Status'))
                                    ->options(collect(AnswerStatus::cases())->mapWithKeys(fn (AnswerStatus $s) => [
                                        $s->value => $s->label(),
                                    ]))
                                    ->default(AnswerStatus::Published->value)
                                    ->required(),
                                Toggle::make('is_published')
                                    ->label(__('Publish Answer (Publicly Visible)'))
                                    ->default(true),
                                DateTimePicker::make('answered_at')
                                    ->label(__('Answer Time'))
                                    ->default(now()),
                                Hidden::make('user_id')
                                    ->default(fn () => auth()->id()),
                            ])
                            ->columns(3)
                            ->collapsible()
                            ->defaultItems(0)
                            ->addActionLabel(__('Provide New Answer')),
                    ]),
            ]);
    }
}
