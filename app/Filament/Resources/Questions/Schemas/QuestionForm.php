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
                Section::make('Informasi Penanya & Pertanyaan')
                    ->components([
                        TextInput::make('name')
                            ->label('Nama Penanya')
                            ->required(),
                        TextInput::make('email')
                            ->label('Alamat Email')
                            ->email()
                            ->required(),
                        TextInput::make('phone')
                            ->label('Nomor Telepon / WA'),
                        Select::make('topic_id')
                            ->label('Topik')
                            ->relationship('topic', 'name')
                            ->searchable()
                            ->preload(),
                        TextInput::make('subject')
                            ->label('Subjek Pertanyaan')
                            ->required()
                            ->columnSpanFull(),
                        Textarea::make('body')
                            ->label('Isi Pertanyaan Lengkap')
                            ->rows(4)
                            ->required()
                            ->columnSpanFull(),
                        Select::make('status')
                            ->label('Status Pertanyaan')
                            ->options(collect(QuestionStatus::cases())->mapWithKeys(fn (QuestionStatus $s) => [
                                $s->value => $s->label(),
                            ]))
                            ->default(QuestionStatus::Pending->value)
                            ->required(),
                    ])
                    ->columns(2),

                Section::make('Tanggapan / Jawaban Petugas')
                    ->components([
                        Repeater::make('answers')
                            ->label('Riwayat Tanggapan')
                            ->relationship('answers')
                            ->schema([
                                RichEditor::make('body')
                                    ->label('Isi Jawaban Petugas')
                                    ->required()
                                    ->columnSpanFull(),
                                Select::make('status')
                                    ->label('Status Jawaban')
                                    ->options(collect(AnswerStatus::cases())->mapWithKeys(fn (AnswerStatus $s) => [
                                        $s->value => $s->label(),
                                    ]))
                                    ->default(AnswerStatus::Published->value)
                                    ->required(),
                                Toggle::make('is_published')
                                    ->label('Publikasikan Jawaban (Dapat Dilihat Publik)')
                                    ->default(true),
                                DateTimePicker::make('answered_at')
                                    ->label('Waktu Menjawab')
                                    ->default(now()),
                                Hidden::make('user_id')
                                    ->default(fn () => auth()->id()),
                            ])
                            ->columns(3)
                            ->collapsible()
                            ->defaultItems(0)
                            ->addActionLabel('Beri Jawaban Baru'),
                    ]),
            ]);
    }
}
